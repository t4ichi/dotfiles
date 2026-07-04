{ lib, pkgs, ... }:
{
  # Claude Code はネイティブの自己更新インストール（~/.local/share/claude）を使う。
  # Nix でバイナリを固定すると自動更新できず版が遅れるため、
  # 「未導入なら公式インストーラを実行する」処理だけを home-manager で宣言する。
  #   - 新マシン: switch 時に未導入なら自動でネイティブ版を導入（再現的）
  #   - 更新: claude 自身の auto-updater に委譲（Nix では固定しない）
  home.activation.installClaudeCode =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -x "$HOME/.local/bin/claude" ]; then
        echo "Claude Code (native) をインストールします..."
        $DRY_RUN_CMD ${pkgs.bash}/bin/bash -c \
          '${pkgs.curl}/bin/curl -fsSL https://claude.ai/install.sh | bash'
      fi
    '';
}
