{...}: {
  programs.hyprland = {
    enable = true;
  };

  environment.sessionVariables = {
    GDK_SCALE = "2";
    GSK_RENDERER = "ngl";
    NIXOS_OZONE_WL = "1";
  };
}
