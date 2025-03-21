{config, inputs, pkgs, utilities, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.firefox = {
    enable = true;

    configPath = ".zen";

    profiles.main = {
      extensions = {
        force = true;
      };

      settings = utilities.flattenAttrs [] {
        browser = {
          tabs.inTitlebar = 0;
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
      };

      userChrome = ''
        #browser {
          background: ${base00} !important;
        }
      '';
    };

    package = inputs.zen.packages.${pkgs.system}.default;
  };

  stylix.targets.firefox = {
    profileNames = [
      "main"
    ];
  };
}
