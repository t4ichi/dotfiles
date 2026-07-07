{
  description = "taichi's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, home-manager }:
    let
      system = "aarch64-darwin";
      # 公開して問題ないホスト定義。社内マシン等は nix/hosts.local.nix
      # （.gitignore 済み・リポジトリ内なので explorer から編集可）で追加する。
      # username はここに書かず SUDO_USER/USER から導出（flake.nix に社内情報を残さない）。
      # ローカル profile を読むには switch を --impure で実行する必要がある。
      localHosts =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          user = if sudoUser != "" then sudoUser else builtins.getEnv "USER";
          p = "/Users/" + user + "/dotfiles/nix/hosts.local.nix";
        in
        if user != "" && builtins.pathExists p then import p else { };
      hosts = (import ./nix/hosts.nix) // localHosts;
      mkDarwinConfiguration = username: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs username; };
        modules = [
          ./nix/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # 既存ファイルと衝突したら .backup へ退避してから管理下に置く
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./nix/home;
            home-manager.extraSpecialArgs = { inherit inputs username; };
          }
        ];
      };
    in
    {
      darwinConfigurations =
        nixpkgs.lib.mapAttrs (host: profile: mkDarwinConfiguration profile.username) hosts;
    };
}
