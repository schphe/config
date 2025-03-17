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
  };

  outputs = inputs: let
    modules = with inputs; [
      manager.nixosModules.default
      stylix.nixosModules.default
    ] ++ [./conf];

    modules-home = with inputs; [
      anyrun.homeManagerModules.default
    ] ++ [./home];

    global = {
      username = "schphe";
    };

    specialArgs = {
      inherit inputs;
      inherit global;
      inherit modules-home;

      utils = import ./util;
    };
  in {
    nixosConfigurations = {
      macbook = inputs.nixpkgs.lib.nixosSystem {
        modules = modules ++ with inputs; [
          silicon.nixosModules.default
        ] ++ [./host/macbook];

        inherit specialArgs;
        system = "aarch64-linux";
      };
    };
  };
}
