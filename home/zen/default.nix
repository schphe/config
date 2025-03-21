{config, globals, pkgs, utilities, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.firefox = {
    enable = true;

    configPath = ".zen";

    profiles.main = {
      extensions = {
        force = true;

        packages = with pkgs.inputs.firefox-addons; [
          darkreader
          sponsorblock
          ublock-origin
        ];
      };

      settings = utilities.flattenAttrs [] {
        extensions = {
          autoDisableScopes = 0;
        };

        zen = {
          theme = {
            accent-color = base0D;
            gradient = false;
          };

          urlbar = {
            behavior = "normal";
          };

          view = {
            sidebar-expanded = false;
            use-single-toolbar = false;

            grey-out-inactive-windows = false;
          };

          welcome-screen.seen = true;
        };

        browser = {
          tabs.inTitlebar = 0;

          download = {
            dir = "/home/${globals.username}/download";
            folderList = 2;
          };
        };
      };

      userChrome = ''
        #browser {
          background: ${base00} !important;
        }
      '';
    };

    package = pkgs.inputs.zen.default;
  };

  stylix.targets.firefox = {
    profileNames = [
      "main"
    ];
  };

  xdg.mimeApps.defaultApplications = let
    zen = [
      "zen.desktop"
    ];
  in {
    "text/xml" = zen;
    "text/html" = zen;
    "x-scheme-handler/http" = zen;
    "x-scheme-handler/https" = zen;
  };

  home.persistence."/pers/home/${globals.username}" = {
    directories = [
      ".zen"
    ];
  };
}
