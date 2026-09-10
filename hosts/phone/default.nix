{ config, inputs, ... }:

let
  modules = config.flake.nixosModules;
  featureNames = [
    "plasma"
  ];
  features = featureNames |> map (name: modules.${name});
  sshKey = builtins.readFile ./authorized.pub;
in
{
  flake.nixosConfigurations.phone = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.surya.nixosModules.minimal
      inputs.home.nixosModules.home-manager
      ./tether.nix
    ]
    ++ features
    ++ [
      (
        { pkgs, lib, ... }:
        {
          hardware.xiaomi-surya.panel = "huaxing";

          networking.hostName = "phone";
          time.timeZone = "America/Chicago";
          i18n.defaultLocale = "en_US.UTF-8";

          nixpkgs.config.allowUnfree = true;

          users.users.schphe = {
            isNormalUser = true;
            password = "1234";
            extraGroups = [
              "wheel"
              "networkmanager"
              "feedbackd"
            ];
            openssh.authorizedKeys.keys = [ sshKey ];
          };
          users.users.root.openssh.authorizedKeys.keys = [ sshKey ];

          security.sudo.wheelNeedsPassword = lib.mkForce false;

          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "prohibit-password";
          };

          networking.firewall.enable = false;
          networking.networkmanager.enable = true;

          services.journald.settings.Journal.Storage = "persistent";

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

          nix.settings = {
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];
            trusted-users = [ "@wheel" ];
          };

          environment.systemPackages = with pkgs; [
            alsa-utils
            evtest
            iw
            usbutils
          ];

          system.stateVersion = "25.11";
        }
      )
    ];
  };
}
