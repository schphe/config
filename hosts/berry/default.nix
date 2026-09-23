{ config, inputs, ... }:

let
  modules = config.flake.nixosModules;
  featureNames = [
    "network"
    "shell"
    "direnv"
    "agent"
    "upkeep"
    "mdns"
    "tailscale"
    "docker"
  ];
  features = featureNames |> map (name: modules.${name});
in
{
  flake.nixosConfigurations.berry = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.hardware.nixosModules.raspberry-pi-4
      inputs.home.nixosModules.home-manager
      inputs.persist.nixosModules.impermanence
      inputs.sops.nixosModules.sops
      (
        { modulesPath, ... }:
        {
          imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];
        }
      )
    ]
    ++ features
    ++ [
      (
        { pkgs, ... }:
        {
          networking.hostName = "berry";
          time.timeZone = "America/Chicago";
          i18n.defaultLocale = "en_US.UTF-8";

          boot.kernelPackages = pkgs.linuxPackages;
          hardware.raspberry-pi.firmware.uboot.enable = true;

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
          };
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

          users.users.schphe = {
            isNormalUser = true;
            uid = 1000;
            description = "schphe";
            extraGroups = [ "wheel" ];
            shell = pkgs.zsh;
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMSl9NpcIwEecJVY33Dbzap5Bb9MiHyBLgBEptkfXT1A berry"
            ];
          };
          programs.zsh.enable = true;

          users.users.root.hashedPassword = "!";

          networking.networkmanager.enable = true;
          networking.firewall = {
            enable = true;
            allowedTCPPorts = [
              80
              443
            ];
            allowedUDPPorts = [ 443 ];
          };

          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
              PermitRootLogin = "no";
            };
          };

          security.polkit.enable = true;
          security.sudo.wheelNeedsPassword = false;

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
        }
      )
    ];
  };
}
