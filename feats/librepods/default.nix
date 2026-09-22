{
  flake.nixosModules.librepods = _: {
    programs.librepods.enable = true;

    users.users.schphe.extraGroups = [ "librepods" ];

    home-manager.users.schphe.systemd.user.services.librepods = {
      Unit = {
        Description = "LibrePods AirPods daemon";
        PartOf = [ "graphical-session.target" ];
        After = [
          "graphical-session.target"
          "noctalia.service"
        ];
        StartLimitIntervalSec = 60;
        StartLimitBurst = 3;
      };
      Service = {
        ExecStart = "/run/wrappers/bin/librepods";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
