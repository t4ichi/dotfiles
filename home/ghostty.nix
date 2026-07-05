{ pkgs, ... }:
{
  # ghostty を完全に Nix 管理（設定を宣言的に生成）。
  # macOS ではソースビルド不可のため package は公式 .dmg 再パッケージ版を指定。
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    settings = {
      # color
      theme = "catppuccin-mocha";

      # font（複数指定はリストで。フォールバック順）
      font-family = [
        "JetBrainsMono Nerd Font Mono"
        "Hiragino Kaku Gothic ProN"
      ];
      font-feature = "-dlig";
      font-size = 13;

      # option
      macos-option-as-alt = true;

      # background
      background-opacity = "0.9";
      background-blur-radius = 20;

      # titlebar
      macos-titlebar-style = "hidden";

      # window
      window-padding-x = "0,20";
      window-padding-y = "0,20";
      window-height = 40;
      window-width = 140;
      window-padding-balance = true;

      desktop-notifications = true;
    };
  };
}
