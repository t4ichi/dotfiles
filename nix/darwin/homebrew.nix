{ ... }:
{
  # GUI アプリ・CLI(bottle) を Homebrew で宣言的に管理する。
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;   # switch のたびに brew update しない
      upgrade = false;      # 自動アップグレードしない
      cleanup = "none";     # 宣言外の brew/cask を削除しない（安全のため none）
    };

    taps = [ ];

    brews = [
      "herdr"   # nixpkgs版は darwin キャッシュが未成熟なため brew の bottle を使う
    ];

    casks = [
      "arc"
      "google-chrome"
      "claude"
      "slack"
      "obsidian"
      "docker-desktop"
      "visual-studio-code"
      "postman"
      "raycast"
      "nani"
      "ghostty"   # 設定は config/ghostty/config を symlink 管理（nix/home/symlinks.nix）
      "notion"
      "qlmarkdown"   # Finderでmdファイルをスペースキーでプレビュー
    ];
  };
}
