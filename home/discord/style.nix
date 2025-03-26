{config, utilities, ...}:
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

      --bg-brand: #83a598 !important;

      --theme-base-color: ${base00};
      --theme-base-color-amount: 100%;

      --border-faint: #00000000 !important;
      --chat-background-default: #00000000 !important;

      --custom-app-top-bar-height: 0px;
    }

    .guilds_c48ade {
      margin-top: 15px;
    }

    .button_e6e74f,
    .trailing_c38106,
    .emojiButton__04eed {
      display: none;
    }

    .buttons__74017 {
      margin-right: -15px !important;
    }

    .panels_c48ade {
      background: #00000000 !important;
    }

    .container_c48ade {
      --custom-chat-input-margin-bottom: 5px;
    }

    @media (max-width: 1000px) {
      .buttons__74017,
      .sidebar_c48ade,
      .toolbar__9293f {
        display: none !important;
      }
    }
  '' + utilities.cssFontsGlobal config;
}
