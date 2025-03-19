{...}: {
  imports = [
    ./input.nix
    ./layout.nix
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
        enable_swallow = true;
        swallow_regex = "^(kitty)$";

        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
    };
  };

  services.xremap = {
    withHypr = true;
  };
}
