{ ... }:
{
  # user.name / user.email はここでは一切管理しない（公開リポジトリのため）。
  # 実体は各マシンで手動作成する Nix 管理外のプレーンファイルに置き、
  # git 自身が実行時に読みに行く（Nixの評価時には一切読み込まない）。
  #   ~/.config/git/identity.gitconfig          既定（会社/個人はマシンごとに手動で書き分ける）
  #   ~/.config/git/identity-personal.gitconfig  ~/dotfiles 配下だけ強制的にこちらを使う
  programs.git = {
    enable = true;

    settings = {
      include.path = "~/.config/git/identity.gitconfig";
    };

    includes = [
      {
        condition = "gitdir:~/dotfiles/";
        path = "~/.config/git/identity-personal.gitconfig";
      }
    ];
  };
}
