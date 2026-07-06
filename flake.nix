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
      # ホスト名 (scutil --get LocalHostName) ごとのユーザー名
      hosts = {
        "taichinoMacBook-Pro" = "taichiitou";
        "REDACTED-HOST" = "REDACTED-USER";
      };
      mkDarwinConfiguration = username: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs username; };
        modules = [
          ./darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # 既存ファイルと衝突したら .backup へ退避してから管理下に置く
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./home/default.nix;
            home-manager.extraSpecialArgs = { inherit inputs username; };
          }
        ];
      };
    in
    {
      darwinConfigurations = nixpkgs.lib.mapAttrs (host: username: mkDarwinConfiguration username) hosts;
    };
}
