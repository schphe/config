{
  flake.nixosModules.mail =
    {
      config,
      pkgs,
      ...
    }:
    let
      colors = config.lib.stylix.colors.withHashtag;
      font = config.stylix.fonts.sansSerif.name;
      profile = ".config/thunderbird/04okt13v.default";

      protonmailBridgeGui = pkgs.protonmail-bridge-gui.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        postFixup = (old.postFixup or "") + ''
          wrapProgram "$out/bin/protonmail-bridge-gui" \
            --prefix QML_IMPORT_PATH : "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml" \
            --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
        '';
      });
    in
    {
      programs.thunderbird = {
        enable = true;
      };

      home-manager.users.schphe = {
        home.packages = [ protonmailBridgeGui ];

        home.file."${profile}/chrome/userChrome.css".text = ''
          :root {
            --layout-background-0: ${colors.base00};
            --layout-background-1: ${colors.base00};
            --layout-background-2: ${colors.base01};
            --layout-background-3: ${colors.base01};
            --layout-color-0: ${colors.base06};
            --layout-color-1: ${colors.base05};
            --layout-color-2: ${colors.base04};
            --layout-border-0: ${colors.base02};
            --layout-border-1: ${colors.base03};

            --color-canvas: ${colors.base00};
            --color-panel-background: ${colors.base01};
            --color-text-base: ${colors.base05};
            --color-text-muted: ${colors.base04};

            --selected-item-color: ${colors.base0D};
            --selected-item-text-color: ${colors.base00};

            --toolbar-bgcolor: ${colors.base00} !important;
            --toolbar-color: ${colors.base05} !important;
            --tabs-toolbar-background-color: ${colors.base00} !important;
            --tab-selected-bgcolor: ${colors.base01} !important;

            --sidebar-background-color: ${colors.base00} !important;
            --sidebar-text-color: ${colors.base05} !important;

            --tree-view-bg: ${colors.base00} !important;
            --tree-view-color: ${colors.base05} !important;
            --tree-card-background: ${colors.base01} !important;
            --tree-view-header-bg: ${colors.base00} !important;

            --spaces-bg-color: ${colors.base00} !important;
            --spaces-button-active-bgcolor: ${colors.base02} !important;

            --search-field-background: ${colors.base01} !important;
            --search-field-color: ${colors.base05} !important;

            --button-background-color: ${colors.base01} !important;
            --button-text-color: ${colors.base05} !important;
            --button-primary-background-color: ${colors.base0D} !important;
            --button-primary-text-color: ${colors.base00} !important;

            --in-content-page-background: ${colors.base00} !important;
            --in-content-page-color: ${colors.base05} !important;
          }

          .titlebar-buttonbox .titlebar-close,
          .titlebar-close {
            display: none !important;
          }

          * {
            font-family: "${font}" !important;
          }
        '';

        home.file."${profile}/user.js".text = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("ui.systemUsesDarkTheme", 1);
          user_pref("layout.css.prefers-color-scheme.content-override", 0);
          user_pref("mail.uidensity", 0);
        '';
      };
    };
}
