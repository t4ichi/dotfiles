{ config, ... }:
let
  dots = "${config.home.homeDirectory}/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  # 配置写像の登録簿（このリポジトリで「デプロイ先を知っている」唯一の場所）。
  #   左辺 = home からの配置先パス（~/.config などデプロイの都合）
  #   右辺 = リポジトリ内の責務ベースのソースパス（tools/ secrets/ .claude/）
  # mkOutOfStoreSymlink により、リポジトリを直接編集→即反映（rebuild 不要）を維持する。
  home.file = {
    # config/*（アプリが実行時に読む live 設定ペイロード）
    ".config/nvim".source = link "${dots}/config/nvim";
    ".config/ghostty/config".source = link "${dots}/config/ghostty/config";
    ".config/herdr/config.toml".source = link "${dots}/config/herdr/config.toml";
    ".config/mise/config.toml".source = link "${dots}/config/mise/config.toml";

    # Claude（.claude はプロジェクト設定を兼ねるためルート据え置き。skills/settings を配置）
    ".claude/settings.json".source = link "${dots}/.claude/settings.json";
    ".claude/skills".source = link "${dots}/.claude/skills";

    # secrets/*（.gitignore 済みの実体を path 参照するだけ。初回のみ手動作成）
    # 存在しないマシンでは proxy を zsh 側が [ -f ... ] でスキップする。
    ".config/git/identity.gitconfig".source = link "${dots}/secrets/git/identity.gitconfig";
    ".config/git/identity-personal.gitconfig".source = link "${dots}/secrets/git/identity-personal.gitconfig";
    ".config/zsh/proxy.env".source = link "${dots}/secrets/zsh/proxy.env";
    # VSCode は programs.vscode（nix/home/vscode.nix）で宣言管理
  };
}
