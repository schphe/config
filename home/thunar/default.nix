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
}
