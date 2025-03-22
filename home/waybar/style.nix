{config, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.waybar.style = ''
      * {
        border-radius: 0px;
        border-width: 4px;
        font-weight: normal;
      }

      tooltip {
        background: ${base00};
        border-color: ${base0E};
      }

      #workspaces button {
        color: ${base05};
        padding-left: 9px;
        padding-right: 8px;
      }
      #workspaces button.active,
      #workspaces button.focused {
        background: ${base0D};
        color: ${base00};
      }
    '' + (builtins.readFile ./base.css);

  stylix.targets.waybar = {
    enable = false;
  };
}
