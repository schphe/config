{config, globals, lib, pkgs, utilities, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.firefox = {
    enable = true;

    configPath = ".zen";

    profiles.default = {
      extensions = {
        force = true;

        packages = with pkgs.inputs.firefox-addons; [
          darkreader
          proton-pass
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

          display = {
            use_document_fonts = 0;
          };

          download = {
            dir = "/home/${globals.username}/download";
            folderList = 2;
          };
        };

        font = {
          name-list = {
            emoji = config.stylix.fonts.emoji.name;
          };
        };
      };

      userChrome = ''
        #browser {
          background: ${base00} !important;
        }
      '' + utilities.cssFontsGlobal config;
    };

    package = pkgs.inputs.zen.default;
  };

  stylix.targets.firefox = {
    profileNames = [
      "default"
    ];
  };

  services.xremap.config.keymap = [{
    name = "open zen browser";

    remap = {
      super-w = {
        launch = ["zen"];
      };
    };
  }];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = let
      zen = [
        "zen.desktop"
      ];
    in {
      "text/xml" = zen;
      "text/html" = zen;
      "x-scheme-handler/http" = zen;
      "x-scheme-handler/https" = zen;
    };
  };

  home.persistence."/pers/home/${globals.username}" = {
    directories = [
      ".zen"
    ];
  };
}
