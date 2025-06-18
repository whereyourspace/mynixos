{
  description = "User environment configuration flake";

  inputs = let
    system-version = "24.11";
  in
  {
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-${system-version}"
    home-manager.url = "github:nix-community/home-manager?ref=release-${system-version}";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    homeConfiguration."$USER" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [ home.nix ];
    };
  };
}
