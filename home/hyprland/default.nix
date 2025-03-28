{lib, pkgs, ...}: {
  imports = [
    ./input.nix
    ./layout.nix
  ];

  home.packages = [
    pkgs.hyprpicker
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    package = null;
    portalPackage = null;

    settings = {
      exec-once = [
        "waybar"
      ];

      general = {
        border_size = 6;

        gaps_in = 0;
        gaps_out = 0;

        layout = "dwindle";
      };

      decoration = {
        shadow = {
          enabled = false;
        };
      };

      dwindle = {
        preserve_split = true;
        smart_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      monitor = ",preferred,auto,1.6";

      xwayland = {
        force_zero_scaling = true;
      };
    };

    systemd = {
      variables = [
        "--all"
      ];
    };
  };

  services.xremap = {
    withHypr = true;
  };
}
