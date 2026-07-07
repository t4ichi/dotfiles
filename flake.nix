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
      # 公開して問題ないホスト定義。社内マシン等は /etc/dotfiles/hosts.local.nix
      # （git 管理外・各マシンで手動作成）で追加する。ローカル profile を読むには
      # switch を --impure で実行する必要がある。
      localHosts =
        if builtins.pathExists /etc/dotfiles/hosts.local.nix
        then import /etc/dotfiles/hosts.local.nix
        else { };
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
