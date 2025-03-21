{globals, pkgs, packages, ...}: let
  cursor = {
    size = 24;
  
    name = "macOS";
    package = pkgs.apple-cursor;
  };

  font = {
    name = "Monocraft";
    package = pkgs.monocraft;
  };

  emoji = {
    name = "SerenityOS Emoji Regular";
    package = packages.serenity-emoji;
  };

  icon = {
    name = "Colloid-Gruvbox-Dark";

    package = (pkgs.colloid-icon-theme.overrideAttrs (old: {
      preInstall = old.preInstall or "" + ''
        echo "[categories@2x/22]" >> ./src/index.theme
        echo "Size=22" >> ./src/index.theme
        echo "Scale=2" >> ./src/index.theme
        echo "Context=Categories" >> ./src/index.theme
        echo "Type=Fixed" >> ./src/index.theme
      '';
    })).override {
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
      inherit emoji;

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
