{ inputs, ... }:

{
  flake.nixosModules.helium =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      pinned = true;

      crxUrl =
        id:
        "https://clients2.google.com/service/update2/crx"
        + "?response=redirect&prodversion=140.0.0.0&acceptformat=crx3&x=id%3D${id}%26uc";

      extensions = {
        proton-pass = {
          id = "ghmbeldphafepmbegfdlkpapadhbakde";
          version = "1.40.1";
          hash = "sha256-t300BfQxxFaKtnl8D+9jNuHLjLrd0LMHdnAV3gzNLD4=";
        };
        sponsorblock = {
          id = "mnjggcdmjocbbbhaepdhchncahnbgone";
          version = "6.1.6";
          hash = "sha256-VYf+K2qZRhAcoN3nxu/nanVcXuW21uY9/EjH9zbNtP8=";
        };
        tampermonkey = {
          id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";
          version = "5.5.0";
          hash = "sha256-vK7AgsQ54RxN9oP0PQfprD1EOSUdcrkcW0Uvl32sFdU=";
        };
        darkreader = {
          id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
          version = "4.9.130";
          hash = "sha256-hPyoKRkZ9of85y7XLHFpel8gOvbsQB52eOjrRFQARr0=";
        };
      };

      updateManifest =
        name: ext:
        let
          crx = pkgs.fetchurl {
            name = "${name}-${ext.version}.crx";
            url = ext.url or (crxUrl ext.id);
            inherit (ext) hash;
          };
        in
        pkgs.writeText "${name}-updates.xml" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <gupdate xmlns="http://www.google.com/update2/response" protocol="2.0">
            <app appid="${ext.id}">
              <updatecheck codebase="file://${crx}" version="${ext.version}" />
            </app>
          </gupdate>
        '';

      extensionSettings = lib.mapAttrs' (
        name: ext:
        lib.nameValuePair ext.id (
          {
            installation_mode = "force_installed";
          }
          // (
            if pinned then
              {
                update_url = "file://${updateManifest name ext}";
                override_update_url = true;
              }
            else
              { update_url = "https://clients2.google.com/service/update2/crx"; }
          )
        )
      ) extensions;

      inherit (import ./theme.nix { inherit config pkgs lib; }) theme recolor;

      policies = {
        ComponentUpdatesEnabled = false;
        DefaultBrowserSettingEnabled = false;
        PromotionalTabsEnabled = false;

        MetricsReportingEnabled = false;
        SearchSuggestEnabled = false;
        UrlKeyedAnonymizedDataCollectionEnabled = false;
        BrowserSignin = 0;
        SyncDisabled = true;
        BrowserAddPersonEnabled = false;
        ProfilePickerOnStartupAvailability = 1;

        PasswordManagerEnabled = false;

        ExtensionSettings = extensionSettings;
        ExtensionInstallSources = lib.optionals pinned [ "file:///*" ];
      };

      policyFile = (pkgs.formats.json { }).generate "helium-policies.json" policies;

      heliumVersion = "0.16.5.1";

      package =
        (pkgs.callPackage "${inputs.helium}/helium.nix" {
          flags = [
            "--ozone-platform-hint=auto"
            "--enable-features=WaylandWindowDecorations"
            "--load-extension=${theme},${recolor}"
          ];
        }).overrideAttrs
          (_: {
            src = pkgs.fetchurl {
              url =
                "https://github.com/imputnet/helium-linux/releases/download/"
                + "${heliumVersion}/helium-bin_${heliumVersion}-1_arm64.deb";
              hash = "sha256-pJUSdkdrNLgDMCqnEPUxdpS6MJjeCgG2ztHON4DS9qQ=";
            };
          });
    in
    {
      environment.systemPackages = [ package ];

      stylix.targets.chromium.enable = false;

      environment.etc = {
        "net.imput.helium/policies/managed/nixos.json".source = policyFile;
        "helium/policies/managed/nixos.json".source = policyFile;
        "chromium/policies/managed/nixos.json".source = policyFile;
      };

      home-manager.users.schphe =
        { config, ... }:
        let
          colors = config.lib.stylix.colors.withHashtag;
        in
        {
          xdg.configFile."darkreader/base16-settings.json".text = builtins.toJSON {
            schemeVersion = 0;
            enabled = true;
            fetchNews = false;
            theme = {
              mode = 1;
              brightness = 100;
              contrast = 100;
              grayscale = 0;
              sepia = 0;
              useFont = true;
              fontFamily = "Berkeley Mono Variable";
              textStroke = 0;
              engine = "dynamicTheme";
              stylesheet = "";
              darkSchemeBackgroundColor = colors.base00;
              darkSchemeTextColor = colors.base05;
              lightSchemeBackgroundColor = colors.base07;
              lightSchemeTextColor = colors.base00;
              scrollbarColor = colors.base03;
              selectionColor = colors.base0D;
              styleSystemControls = true;
              lightColorScheme = "Default";
              darkColorScheme = "Default";
              immediateModify = false;
            };
            presets = [ ];
            customThemes = [ ];
            enabledByDefault = true;
            enabledFor = [ ];
            disabledFor = [ ];
            changeBrowserTheme = false;
            syncSettings = true;
            syncSitesFixes = false;
            automation = {
              enabled = true;
              mode = "system";
              behavior = "OnOff";
            };
            time = {
              activation = "18:00";
              deactivation = "9:00";
            };
            location = {
              latitude = null;
              longitude = null;
            };
            previewNewDesign = false;
            previewNewestDesign = false;
            enableForPDF = true;
            enableForProtectedPages = false;
            enableContextMenus = false;
            detectDarkTheme = true;
          };

          xdg.mimeApps = {
            enable = true;
            defaultApplications = {
              "text/html" = "helium.desktop";
              "x-scheme-handler/http" = "helium.desktop";
              "x-scheme-handler/https" = "helium.desktop";
              "x-scheme-handler/about" = "helium.desktop";
              "x-scheme-handler/unknown" = "helium.desktop";
            };
          };

          home.sessionVariables.BROWSER = "helium";
        };
    };
}
