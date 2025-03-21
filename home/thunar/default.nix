{...}: {
  home.file.".config/xfce4/helpers.rc".text = ''
    TerminalEmulator=kitty
    TerminalEmulatorDismissed=true
  '';

  services.xremap.config.keymap = [
    {
      name = "open thunar";

      remap = {
        super-shift-enter = {
          launch = ["thunar"];
        };
      };
    }
  ];

  xdg.mimeApps.defaultApplications = let
    thunar = [
      "thunar.desktop"
    ];
  in {
    "inode/directory" = thunar;
    "application/x-gnome-saved-search" = thunar;
  };

}
