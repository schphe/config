{
  config,
  pkgs,
  lib,
}:

let
  colors = config.lib.stylix.colors;

  themeKey =
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAujqjjooQ9vh7EnWkpJd7aT1LGN5z/yNwXTHauKdW"
    + "GyfF5jTBjQX5T9RxxiK4H5SkapuduxSu0HSaWhGUvPGGyxFSC1vuSa/InvGx6iBGM2TfNj4rjMkmVTai/IQz"
    + "M+n7UeANCuHSFWrs8XY4uTIX5+J2vRsDoLLTGx/TjOQjmao2mrL3KBEZxYCS7oGu9UJgU3kOIHk191c9GDDJ"
    + "F7BvzydPd7Icb2Ee94LWn2QXMhAUrsXC0CNt64btyUnvGBny5W2/Nrw9SmLmqoWylG8BQuFK7ev5ZNYojhlR"
    + "WE5CG0PzFy5kD33k4eZ27LqtZ72w1lAPGpNu/xkELGayIiulUQIDAQAB";

  rgb = name: [
    (lib.toInt colors."${name}-rgb-r")
    (lib.toInt colors."${name}-rgb-g")
    (lib.toInt colors."${name}-rgb-b")
  ];

  theme = pkgs.writeTextDir "manifest.json" (
    builtins.toJSON {
      manifest_version = 3;
      name = "Stylix";
      version = "1.0";
      key = themeKey;
      theme = {
        colors = {
          frame = rgb "base00";
          frame_inactive = rgb "base00";
          frame_incognito = rgb "base01";
          frame_incognito_inactive = rgb "base01";

          toolbar = rgb "base00";
          omnibox_background = rgb "base01";
          omnibox_text = rgb "base05";

          tab_text = rgb "base06";
          tab_background_text = rgb "base04";
          tab_background_text_inactive = rgb "base03";

          bookmark_text = rgb "base05";
          toolbar_button_icon = rgb "base05";

          ntp_background = rgb "base00";
          ntp_text = rgb "base05";
        };
        tints.buttons = [
          (-1)
          (-1)
          (-1)
        ];
        properties.ntp_logo_alternate = 1;
      };
    }
  );

  recolorKey =
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvYWkaf3E21rxetEdYv9ODCcI/zuSDDeK6zOau1HQ"
    + "yQcTrIb8mI3tTVFWNHpMc7uu7HdAprNaoQW70SdBdsE6+6YZUtzST+wRe/wUtkW9oD1Wzfr+HIqZszq87GVX"
    + "qJ861VedDqcn/29K1IafgCgQos+YHLfBY0ntB1V6NXm00TJWPEnNDjUgnE2mvXA7tfsoRRG9jos9WIgDylpF"
    + "TF0u21NX9jJTCGpIn51YAux4Qjt4ZgLKj7wVTS6iEqerMCBd/gC4UEtkQz59VePdxogMt1HEx9QJVY1HK8lx"
    + "gzpVmvGqlFCy+fQLVaA+04AdIVHfEiTMGbQuyVPJkFJbkoAHpwIDAQAB";

  hex = name: colors.withHashtag.${name};

  recolor = pkgs.runCommand "helium-recolor" { } ''
    mkdir -p $out
    cp ${./recolor/recolor.js} $out/recolor.js

    cat > $out/palette.js <<'EOF'
    globalThis.__STYLIX_PALETTE__ = ${
      builtins.toJSON {
        polarity = "dark";
        font = config.stylix.fonts.monospace.name;
        background = hex "base00";
        foreground = hex "base05";
        selection = hex "base0D";
        scrollbar = hex "base03";
        ramp = map hex [
          "base00"
          "base01"
          "base02"
          "base03"
          "base04"
          "base05"
          "base06"
          "base07"
        ];
        accents = map hex [
          "base08"
          "base09"
          "base0A"
          "base0B"
          "base0C"
          "base0D"
          "base0E"
          "base0F"
        ];
      }
    };
    EOF

    cat > $out/manifest.json <<'EOF'
    ${builtins.toJSON {
      manifest_version = 3;
      name = "Stylix Recolor";
      version = "1.0";
      key = recolorKey;
      content_scripts = [
        {
          matches = [ "<all_urls>" ];
          js = [
            "palette.js"
            "recolor.js"
          ];
          run_at = "document_start";
          all_frames = true;
        }
      ];
    }}
    EOF
  '';
in
{
  inherit theme recolor;
}
