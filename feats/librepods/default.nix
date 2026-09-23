{
  flake.nixosModules.librepods = _: {
    nixpkgs.overlays = [
      (_: prev: {
        librepods = prev.librepods.overrideAttrs (old: {
          version = "0-unstable-2026-09-22";

          src = prev.fetchFromGitHub {
            owner = "harveywuk";
            repo = "librepods";
            rev = "4ed49df0b301ac3e6fba9c81dfbbb6726cc52201";
            hash = "sha256-Ygoqz5lnGMwZkys+Q4c4pyAUI0llvpGZ/ij5E91CkAg=";
          };

          sourceRoot = "source";
          buildInputs = old.buildInputs ++ [ prev.qt6.qtdeclarative ];
        });
      })
    ];

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
