{config, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.nixcord.quickCss = ''
    :root {
      ${builtins.concatStringsSep "\n      " (builtins.genList (i:
        let num = 100 + (i * 30) + (if i > 8 then 15 else 0);
        in "--brand-${toString num}: ${base0D};"
      ) 25)}
    }

    .recentsIcon_ea0547,
    .recentsIcon_c99c29,
    .iconWrapper__9293f,
    .anchor_edefb8 {
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
