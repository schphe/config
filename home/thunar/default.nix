{globals, ...}: {
  services.xremap.config.keymap = [{
    name = "open thunar";

    remap = {
      super-shift-enter = {
        launch = ["thunar"];
      };
    };
  }];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = let
      thunar = [
        "thunar.desktop"
      ];
    in {
      "inode/directory" = thunar;
      "inode/mount-point" = thunar;
    };
  };

  home.file.".config/xfce4/helpers.rc".text = ''
    TerminalEmulator=${globals.terminal}
    TerminalEmulatorDismissed=true
  '';

  home.persistence."/pers/home/${globals.username}" = {
    directories = [
      ".config/xfce4/xfconf"
    ];
  };
}
