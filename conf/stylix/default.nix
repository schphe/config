{pkgs, ...}: let
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
    name = "Colloid-teal-nord-dark";
    package = pkgs.colloid-icon-theme.override {
      colorVariants = ["teal"];
      schemeVariants = ["nord"];
    };
  };

  polarity = "dark";

  theme = "ayu-dark";

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

  home-manager.sharedModules = [{
    stylix.iconTheme = icon;
  }];
}
