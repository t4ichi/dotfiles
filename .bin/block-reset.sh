#!/bin/bash
set -euo pipefail

command -v jq &>/dev/null || exit 0

# Read and discard stdin (ccstatusline passes Claude JSON via stdin)
cat > /dev/null

OAUTH_CACHE="/tmp/block-reset-oauth.json"
OAUTH_TTL=60

# ─── Helper: ISO8601 → epoch (macOS) ───

_iso_to_epoch() {
  local clean
  clean=$(echo "$1" | sed 's/\.[0-9]*Z$//')
  TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$clean" "+%s" 2>/dev/null
}

# ─── Helper: epoch → reset time string ───

_format_reset() {
  local reset_epoch="$1"
  local utilization="$2"

  local reset_hour
  reset_hour=$(TZ=Asia/Tokyo date -j -r "$reset_epoch" "+%-l%p" 2>/dev/null | tr 'A-Z' 'a-z' | tr -d ' ')

  local used_str=""
  if [ -n "$utilization" ]; then
    used_pct=$(printf "%.0f" "$utilization")
    used_str="${used_pct}% used | "
  fi

  echo "${used_str}Resets ${reset_hour}"
}

# ─── OAuth API (primary) ───

_get_access_token() {
  local raw
  raw=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null) || return 1
  [ -z "$raw" ] && return 1

  local json
  if [[ "$raw" == "{"* ]]; then
    json="$raw"
  else
    json=$(echo "$raw" | xxd -r -p 2>/dev/null) || return 1
  fi

  echo "$json" \
    | grep -o '"accessToken":"[^"]*"' \
    | head -1 \
    | sed 's/"accessToken":"//;s/"$//'
}

_oauth_cache_fresh() {
  [ -f "$OAUTH_CACHE" ] || return 1
  local now mtime
  now=$(date +%s)
  mtime=$(stat -f "%m" "$OAUTH_CACHE" 2>/dev/null) || return 1
  [ $((now - mtime)) -lt "$OAUTH_TTL" ]
}

# Refresh cache if stale (foreground if no cache, background if stale)
_fetch_oauth() {
  local token
  token=$(_get_access_token 2>/dev/null) || return 1
  [ -z "$token" ] && return 1
  local result
  result=$(curl --silent --max-time 5 \
    --header "Authorization: Bearer ${token}" \
    --header "anthropic-beta: oauth-2025-04-20" \
    "https://api.anthropic.com/api/oauth/usage" 2>/dev/null) || return 1
  echo "$result" | jq -e '.five_hour' &>/dev/null || return 1
  echo "$result" > "${OAUTH_CACHE}.tmp" && mv "${OAUTH_CACHE}.tmp" "$OAUTH_CACHE"
}

if ! _oauth_cache_fresh; then
  if [ -f "$OAUTH_CACHE" ]; then
    # Stale cache exists: refresh in background
    ( _fetch_oauth ) & disown 2>/dev/null
  else
    # No cache: must fetch now
    _fetch_oauth 2>/dev/null || true
  fi
fi

# Try OAuth cache
if [ -f "$OAUTH_CACHE" ]; then
  resets_at=$(jq -r '.five_hour.resets_at // empty' "$OAUTH_CACHE" 2>/dev/null) || resets_at=""
  utilization=$(jq -r '.five_hour.utilization // empty' "$OAUTH_CACHE" 2>/dev/null) || utilization=""
  if [ -n "$resets_at" ]; then
    reset_epoch=$(_iso_to_epoch "$resets_at")
    if [ -n "$reset_epoch" ]; then
      _format_reset "$reset_epoch" "$utilization"
      exit 0
    fi
  fi
fi
