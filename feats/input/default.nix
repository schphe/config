{
  flake.nixosModules.input =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      home-manager.users.schphe.i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;

          addons = with pkgs; [
            fcitx5-gtk
            fcitx5-mozc
            kdePackages.fcitx5-qt
          ];

          systemd.enable = true;

          themes.stylix.theme = {
            "InputPanel/Background" = {
              Image = lib.mkForce "";
              BorderWidth = lib.mkForce 1;
              BorderColor = lib.mkForce colors.base03;
            };
            "Menu/Background" = {
              Image = lib.mkForce "";
              BorderWidth = lib.mkForce 1;
              BorderColor = lib.mkForce colors.base03;
            };
          };

          settings.globalOptions.Behavior = {
            ShowInputMethodInformation = false;
            ShowInputMethodInformationWhenFocusIn = false;
            ShowFirstInputMethodInformation = false;
          };

          settings.inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "tr";
              DefaultIM = "keyboard-tr";
            };
            "Groups/0/Items/0".Name = "keyboard-tr";
            "Groups/0/Items/1".Name = "mozc";
            GroupOrder."0" = "Default";
          };
        };
      };
    };
}
