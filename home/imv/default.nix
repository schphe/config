{config, ...}:
  with config.lib.stylix.colors.withHashtag;
{
  programs.imv = {
    enable = true;

    settings = {
      options = {
        background = base00;
      };
    };
  };
}
