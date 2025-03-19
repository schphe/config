{
  description = "my personal nix cconfig";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs";
    };

    silicon = {
      url = "github:tpwrules/nixos-apple-silicon/19b1103d09b4be12bdbf4c713b0e45fc434b5f6a";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    persist = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
    };

    anyrun-cliphist = {
      url = "github:wuliuqii/anyrun-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    modules = with inputs; [
      manager.nixosModules.default
      persist.nixosModules.default
      stylix.nixosModules.stylix
    ] ++ [./conf];

    modules-home = with inputs; [
      persist.homeManagerModules.default
      nixcord.homeManagerModules.default
      anyrun.homeManagerModules.default
      xremap.homeManagerModules.default
    ] ++ [./home];

    globals = {
      username = "schphe";
    };

    specialArgs = {
      inherit inputs;
      inherit globals;
      inherit modules-home;

      util = import ./util inputs.nixpkgs.lib;
    };
  in {
    nixosConfigurations = {
      macbook = inputs.nixpkgs.lib.nixosSystem {
        modules = modules ++ (with inputs; [
          silicon.nixosModules.default
        ]) ++ [./host/macbook];

        inherit specialArgs;
        system = "aarch64-linux";
      };
    };
  };
}
