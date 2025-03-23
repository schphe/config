{globals, pkgs, ...}: {
  services.greetd = {
    enable = true;
    
    settings = let
      command = "Hyprland > /dev/null";
    in rec {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd '${command}'";
        user = globals.username;
      };

      initial_session = {
        command = command;
        user = globals.username;
      };
    };
  };
}
