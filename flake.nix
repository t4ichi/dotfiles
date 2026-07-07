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
      # ホスト定義は nix/hosts/<hostname>.nix に置く（ファイル名=ホスト名）。
      # flake.nix は具体名を持たず、ディレクトリを走査して自動生成する。
      hostsDir = ./nix/hosts;
      hostNames = map (nixpkgs.lib.removeSuffix ".nix")
        (builtins.attrNames (builtins.readDir hostsDir));
      mkDarwinConfiguration = hostname:
        let
          profile = import (hostsDir + "/${hostname}.nix");
          inherit (profile) username;
        in
        nix-darwin.lib.darwinSystem {
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
      darwinConfigurations = nixpkgs.lib.genAttrs hostNames mkDarwinConfiguration;
    };
}
