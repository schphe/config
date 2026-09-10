{
  flake.nixosModules.file =
    { pkgs, ... }:
    let
      localeOverride =
        package: domain: translations:
        let
          po = pkgs.writeText "${domain}-en_US.po" (
            ''
              msgid ""
              msgstr "Content-Type: text/plain; charset=UTF-8\n"
            ''
            + pkgs.lib.concatStrings (
              pkgs.lib.mapAttrsToList (msgid: msgstr: ''

                msgid "${msgid}"
                msgstr "${msgstr}"
              '') translations
            )
          );
        in
        package.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.gettext ];
          postInstall = (old.postInstall or "") + ''
            mkdir -p $out/share/locale/en_US/LC_MESSAGES
            msgfmt -o $out/share/locale/en_US/LC_MESSAGES/${domain}.mo ${po}
          '';
        });

      thunar = localeOverride pkgs.thunar "thunar" {
        "File System" = "root";
        "Browse Network" = "browse";
        "Recent" = "recent";
      };

      gvfs = localeOverride pkgs.gvfs "gvfs" {
        "Trash" = "trash";
      };
    in
    {
      programs.xfconf.enable = true;

      services.gvfs = {
        enable = true;
        package = gvfs;
      };
      services.tumbler.enable = true;
      services.udisks2.enable = true;

      home-manager.users.schphe =
        { pkgs, ... }:
        {
          home.packages = [
            thunar
            pkgs.ffmpegthumbnailer
            pkgs.file-roller
            pkgs.thunar-archive-plugin
            pkgs.thunar-volman
          ];

          home.sessionVariables.TERMINAL = "ghostty";

          xfconf.settings.thunar = {
            "last-menubar-visible" = false;
          };

          xdg = {
            configFile."Thunar/uca.xml".text = ''
              <?xml version="1.0" encoding="UTF-8"?>
              <actions>
                <action>
                  <icon>utilities-terminal</icon>
                  <name>Open Ghostty Here</name>
                  <submenu></submenu>
                  <unique-id>1757280000000000-1</unique-id>
                  <command>ghostty --working-directory=&quot;%f&quot;</command>
                  <description>Open a terminal in this directory</description>
                  <range></range>
                  <patterns>*</patterns>
                  <startup-notify/>
                  <directories/>
                </action>
              </actions>
            '';
            terminal-exec = {
              enable = true;
              settings.default = [ "com.mitchellh.ghostty.desktop" ];
            };
            mimeApps = {
              enable = true;
              defaultApplications."inode/directory" = [ "thunar.desktop" ];
            };
          };
        };
    };
}
