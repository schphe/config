{config, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.nixcord.quickCss = ''
    :root {
      ${builtins.concatStringsSep "\n  " (builtins.concatLists
        (builtins.genList (i:
          (builtins.genList (j:
            "--brand-${toString ((100 * i) + 100 + (j * 30))}: ${base0D};"
          ) 3)
        ) 9)
      )}
    }

    .recentsIcon_ea0547,
    .recentsIcon_c99c29 {
      display: none;
    }

    @media (max-width: 1000px) {
      .form_f75fb0 {
        margin-bottom: -20px;
        margin-left: -3px;
        padding: 0px;
      }

      .title_f75fb0 {
        padding-left: 15px;
      }

      .buttons__74017,
      .channelAppLauncher_e6e74f,
      .toolbar__9293f,
      .guilds_c48ade,
      .sidebar_c48ade,
      .toolbar_fc4f04 {
        display: none;
      }
    }
  '';
}
