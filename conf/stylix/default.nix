{assets, globals, packages, pkgs, ...}: let
  cursor = {
    size = 24;
  
    name = "macOS";
    package = pkgs.apple-cursor;
  };

  font = {
    emoji = {
      name = "SerenityOS Emoji Regular";
      package = packages.serenity-emoji;
    };

    text = {
      name = "Monocraft";
      package = pkgs.monocraft;
    };
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

  scheme = {
    base01 = "1d2021";
  };

  theme = "gruvbox-dark-hard";

################################################################

in {
  stylix = {
    enable = true;

    inherit cursor;

    fonts = {
      inherit (font) emoji;

      serif = font.text;
      sansSerif = font.text;
      monospace = font.text;
    };

    override = scheme;

    polarity = "dark";

    image = assets.desk;

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
