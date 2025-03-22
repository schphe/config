{globals, pkgs, ...}: {
  services.greetd = {
    enable = true;
    
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
        user = globals.username;
      };

      initial_session = {
        command = "Hyprland";
        user = globals.username;
      };
    };
  };
}
