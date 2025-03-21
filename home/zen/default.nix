{config, pkgs, utilities, ...}:
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

          uiCustomization.state = builtins.toJSON {
            currentVersion = 21;
            dirtyAreaCache = [
              "nav-bar"
              "PersonalToolbar"
              "TabsToolbar"
              "toolbar-menubar"
              "unified-extensions-area"
              "vertical-tabs"
              "zen-sidebar-bottom-buttons"
            ];
            newElementCount = 2;
            placements = {
              "nav-bar" = [
                "back-button"
                "customizableui-special-spring1"
                "customizableui-special-spring2"
                "forward-button"
                "stop-reload-button"
                "unified-extensions-button"
                "urlbar-container"
                "vertical-spacer"
              ];
              "PersonalToolbar" = [
                "import-button"
                "personal-bookmarks"
              ];
              "TabsToolbar" = [
                "tabbrowser-tabs"
              ];
              "toolbar-menubar" = [
                "menubar-items"
              ];
              "vertical-tabs" = [];
              "widget-overflow-fixed-list" = [];
              "zen-sidebar-bottom-buttons" = [
                "downloads-button"
                "preferences-button"
                "zen-workspaces-button"
              ];
              "zen-sidebar-top-buttons" = [];
            };
            seen = [
              "developer-button"
            ];
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
}
