{...}: {
  wayland.windowManager.hyprland.settings = {
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

    animations = {
      enabled = false;
    };
  };
}
