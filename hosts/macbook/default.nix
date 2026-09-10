{ config, inputs, ... }:

let
  modules = config.flake.nixosModules;
  featureNames = [
    "disk"
    "persist"
    "secret"
    "keyring"
    "niri"
    "input"
    "noctalia"
    "greetd"
    "zed"
    "nvf"
    "podman"
    "direnv"
    "devenv"
    "compat"
    "shell"
    "network"
    "game"
    "wireshark"
    "reverse"
    "agent"
    "memory"
    "battery"
    "stylix"
    "share"
    "anki"
    "helium"
    "discord"
    "whatsapp"
    "mail"
    "document"
    "file"
    "media"
    "vpn"
    "upkeep"
  ];
  features = featureNames |> map (name: modules.${name});
in
{
  flake.nixosConfigurations.macbook = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.silicon.nixosModules.apple-silicon-support
      inputs.disko.nixosModules.disko
      inputs.home.nixosModules.home-manager
      inputs.persist.nixosModules.impermanence
      inputs.sops.nixosModules.sops
      inputs.greeter.nixosModules.default
      inputs.stylix.nixosModules.stylix
      ./disk.nix
      ./hardware.nix
    ]
    ++ features
    ++ [
      ({ inputs, pkgs, ... }: {
        networking.hostName = "macbook";
        time.timeZone = "America/Chicago";
        console.keyMap = "trq";
        i18n.defaultLocale = "en_US.UTF-8";

        nixpkgs.hostPlatform = "aarch64-linux";
        nixpkgs.config.allowUnfree = true;

        nix.settings = {
          accept-flake-config = true;
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
        nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        users.users.schphe = {
          isNormalUser = true;
          uid = 1000;
          description = "schphe";
          extraGroups = [
            "networkmanager"
            "video"
            "wheel"
          ];
          shell = pkgs.zsh;
        };
        programs.zsh.enable = true;

        networking.networkmanager = {
          enable = true;
          wifi.backend = "iwd";
        };
        networking.wireless.iwd = {
          enable = true;
          settings.General.AddressRandomization = "once";
        };
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
        };
        services.openssh.enable = false;

        security.polkit.enable = true;
        services.accounts-daemon.enable = true;
        services.dbus.implementation = "broker";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm-backup";
          extraSpecialArgs = { inherit inputs; };
          users.schphe = {
            home = {
              username = "schphe";
              homeDirectory = "/home/schphe";
              stateVersion = "26.11";
            };
            programs.home-manager.enable = true;
          };
        };

        system.stateVersion = "26.11";
      })
    ];
  };
}
