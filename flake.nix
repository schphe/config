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

    zen = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, ...}@inputs: let
    utilities = import ./util inputs;

    globals = {
      username = "schphe";
    };

    args = {
      inherit inputs;
      inherit globals;
      inherit utilities;
    };

    host = with inputs; [
      manager.nixosModules.default
      persist.nixosModules.default
      stylix.nixosModules.stylix
    ];

    home = with inputs; [
      persist.homeManagerModules.default
      nixcord.homeManagerModules.default
      anyrun.homeManagerModules.default
      xremap.homeManagerModules.default
    ];

  in {
    nixosConfigurations = {
      macbook = utilities.newHost ./host/macbook
      "aarch64-linux" args host home
      (with inputs; [
        silicon.nixosModules.default
      ]);
    };

    inherit (utilities) packages;
  };
}
