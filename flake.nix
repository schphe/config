{
  description = "schphe's NixOS configuration";

  nixConfig.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
  nixConfig.extra-substituters = [ "https://noctalia.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    persist = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home";
    };

    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };

    greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home";
    };

    surya = {
      url = "path:/home/schphe/projects/nixos-xiaomi-surya";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts/macbook
        ./hosts/phone
        ./feats/disk
        ./feats/persist
        ./feats/secret
        ./feats/keyring
        ./feats/niri
        ./feats/input
        ./feats/noctalia
        ./feats/greetd
        ./feats/zed
        ./feats/nvf
        ./feats/podman
        ./feats/direnv
        ./feats/devenv
        ./feats/compat
        ./feats/shell
        ./feats/network
        ./feats/game
        ./feats/wireshark
        ./feats/reverse
        ./feats/agent
        ./feats/memory
        ./feats/battery
        ./feats/stylix
        ./feats/share
        ./feats/anki
        ./feats/helium
        ./feats/discord
        ./feats/whatsapp
        ./feats/mail
        ./feats/document
        ./feats/file
        ./feats/media
        ./feats/vpn
        ./feats/upkeep
        ./feats/plasma
      ];

      systems = [ "aarch64-linux" ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt;
      };
    };
}
