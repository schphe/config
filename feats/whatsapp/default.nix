{
  flake.nixosModules.whatsapp =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      colors = config.lib.stylix.colors.withHashtag;

      plugins = { };

      desktopItem = pkgs.makeDesktopItem {
        name = "oxidezap";
        desktopName = "WhatsApp";
        genericName = "WhatsApp Client";
        comment = "Unofficial WhatsApp client";
        exec = "oxidezap";
        icon = "com.github.eneshecan.WhatsAppForLinux";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        keywords = [
          "whatsapp"
          "oxidezap"
          "messaging"
        ];
        startupWMClass = "oxidezap";
      };

      oxidezap = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "oxidezap";
        version = "0-unstable-2026-09-09";

        src = pkgs.fetchFromGitHub {
          owner = "oxidezap";
          repo = "client";
          rev = "505f3b966d7c244ba07c028051c78f8570bc0b2c";
          hash = "sha256-qwT9VAga89yl+eUdry4//N/G+wrrhgI0KExy3MPG488=";
        };

        cargoHash = "sha256-9bqHBYybqpDNVkxszc4LMHhX2ZBmK5LLzyfnWCrwxwU=";

        dontUseCmakeConfigure = true;

        doCheck = false;

        cargoBuildFlags = [
          "--bin"
          "oxidezap"
          "--bin"
          "oxidezapd"
        ];

        nativeBuildInputs = with pkgs; [
          pkg-config
          protobuf
          makeWrapper
          rustPlatform.bindgenHook
          cmake
        ];

        buildInputs = with pkgs; [
          alsa-lib
          fontconfig
          freetype
          libxkbcommon
          vulkan-loader
          wayland
          libxcb
        ];

        postFixup = ''
          wrapProgram $out/bin/oxidezap \
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath (
                with pkgs;
                [
                  libxkbcommon
                  vulkan-loader
                  wayland
                ]
              )
            }
        '';

        meta = {
          description = "Unofficial WhatsApp client in Rust, built on whatsapp-rust";
          homepage = "https://github.com/oxidezap/client";
          license = lib.licenses.mit;
          mainProgram = "oxidezap";
          platforms = lib.platforms.linux;
        };
      });
    in
    {
      home-manager.users.schphe = {
        home.packages = [
          oxidezap
          desktopItem
        ];

        home.file = {
          ".config/oxidezap/theme.json".text = builtins.toJSON {
            extends = if config.stylix.polarity == "light" then "tokyo-night-light" else "tokyo-night";

            colors = {
              background = colors.base00;
              sidebar = colors.base00;
              secondary = colors.base01;
              elevated = colors.base01;

              foreground = colors.base05;
              muted_foreground = colors.base04;
              subtle_foreground = colors.base03;
              faint_foreground = colors.base03;

              border = colors.base03;
              list_hover = colors.base01;
              list_active = colors.base03;

              primary = colors.base0D;
              ring = colors.base0D;

              danger = colors.base08;
              warning = colors.base0A;
              success = colors.base0B;
              info = colors.base0C;

              scrim = colors.base00;
              on_scrim = colors.base06;
            };

            brand = {
              message_sent = colors.base03;
              message_received = colors.base01;
            };

            density = "comfortable";
            font_size = config.stylix.fonts.sizes.applications + 2;
          };
        }
        // lib.mapAttrs' (
          name: source: lib.nameValuePair ".local/share/oxidezap/plugins/${name}.wasm" { inherit source; }
        ) plugins;
      };
    };
}
