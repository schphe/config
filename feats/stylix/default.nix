{
  flake.nixosModules.stylix =
    { pkgs, ... }:
    let
      berkeleyMonoRuntime = pkgs.runCommand "berkeley-mono-runtime-font" { } ''
        mkdir -p $out/share/fonts/truetype
      '';
    in
    {
      fonts.fontconfig.localConf = ''
        <dir>/run/secrets</dir>
      '';

      stylix = {
        enable = true;
        image = ../../media/image/background.png;
        polarity = "dark";
        base16Scheme = {
          system = "base16";
          name = "Schphe Pastel Gruvbox Hard";
          author = "schphe";
          variant = "dark";
          palette = {
            base00 = "#1d2021";
            base01 = "#1d2021";
            base02 = "#1d2021";
            base03 = "#665c54";

            base04 = "#bdae93";
            base05 = "#d5c4a1";
            base06 = "#ebdbb2";
            base07 = "#fbf1c7";

            base08 = "#d98b7c";
            base09 = "#d9a06f";
            base0A = "#d8c27d";
            base0B = "#a9b88a";
            base0C = "#91b8a1";
            base0D = "#9ab7c0";
            base0E = "#b8a0b0";
            base0F = "#c28b68";
          };
        };

        cursor = {
          package = pkgs.apple-cursor;
          name = "macOS";
          size = 24;
        };

        icons = {
          enable = true;
          package = pkgs.colloid-icon-theme.override {
            schemeVariants = [ "catppuccin" ];
            colorVariants = [ "teal" ];
          };
          dark = "Colloid-Teal-Catppuccin-Dark";
          light = "Colloid-Teal-Catppuccin-Light";
        };

        fonts = {
          monospace = {
            package = berkeleyMonoRuntime;
            name = "Berkeley Mono Variable";
          };
          sansSerif = {
            package = berkeleyMonoRuntime;
            name = "Berkeley Mono Variable";
          };
          serif = {
            package = berkeleyMonoRuntime;
            name = "Berkeley Mono Variable";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };
    };
}
