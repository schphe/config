{globals, pkgs, ...}: let
  cursor = {
    size = 24;
  
    name = "macOS";
    package = pkgs.apple-cursor;
  };

  font = {
    name = "Monocraft";
    package = pkgs.monocraft;
  };

  icon = {
    name = "Colloid-Gruvbox-Dark";

    package = pkgs.colloid-icon-theme.override {
      schemeVariants = ["gruvbox"];
    };
  };

  polarity = "dark";

  theme = "gruvbox-dark-hard";

  wallpaper = ./wallpaper.png;
in {
  stylix = {
    enable = true;

    inherit cursor;
    inherit polarity;

    image = wallpaper;

    fonts = {
      # emoji = font;

      serif = font;
      sansSerif = font;
      monospace = font;
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
  };

  home-manager.users.${globals.username} = {
    stylix.iconTheme = {
      enable = true;

      dark = icon.name;
      package = icon.package;
    };
  };
}
