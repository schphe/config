{...}: {
  programs.hyprland = {
    enable = true;
  };

  environment.sessionVariables = {
    GDK_SCALE = "2";
    NIXOS_OZONE_WL = "1";
  };
}
