{config, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.mpv = {
    enable = true;

    config = {
      background = "color";
      background-color = base00;
    };
  };
}
