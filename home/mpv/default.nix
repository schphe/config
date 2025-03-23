{config, lib, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.mpv = {
    enable = true;

    config = {
      background = "color";
      background-color = lib.mkDefault base00;
    };
  };
}
