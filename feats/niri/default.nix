{
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    environment.systemPackages = with pkgs; [
      wl-clipboard
      xwayland-satellite
    ];

    home-manager.users.schphe =
      { config, ... }:
      {
        services.swayidle = {
          enable = true;
          systemdTargets = [ "niri.service" ];
          timeouts = [
            {
              timeout = 300;
              command = "${config.programs.noctalia.package}/bin/noctalia msg session lock";
            }
            {
              timeout = 600;
              command = "${pkgs.systemd}/bin/systemctl suspend";
            }
          ];
          events = {
            before-sleep = "${config.programs.noctalia.package}/bin/noctalia msg session lock";
            lock = "${config.programs.noctalia.package}/bin/noctalia msg session lock";
          };
        };

        programs.ghostty.enable = true;
        xdg = {
          configFile = {
            "niri/config.kdl".source = ./config.kdl;
            "niri/stylix.kdl".text = with config.lib.stylix.colors.withHashtag; ''
              layout {
                  focus-ring {
                      active-color "${base0D}"
                      inactive-color "${base03}"
                      urgent-color "${base08}"
                  }

                  border {
                      active-color "${base0D}"
                      inactive-color "${base03}"
                      urgent-color "${base08}"
                  }

                  insert-hint {
                      color "${base0D}80"
                  }
              }
            '';
          };
          userDirs = {
            enable = true;
            createDirectories = true;
            desktop = "$HOME/desktop";
            documents = "$HOME/documents";
            download = "$HOME/downloads";
            music = "$HOME/music";
            pictures = "$HOME/pictures";
            projects = "$HOME/projects";
            publicShare = "$HOME/public";
            templates = "$HOME/templates";
            videos = "$HOME/videos";
          };
        };
      };
  };
}
