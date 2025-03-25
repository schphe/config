{globals, pkgs, ...}: {
  home.packages = [
    pkgs.protonvpn-gui
  ];

  services.xremap.config.keymap = [{
    name = "open protonvpn";

    remap = {
      super-shift-v = {
        launch = ["protonvpn-app"];
      };
    };
  }];

  home.persistence."/pers/home/${globals.username}" = {
    directories = [
      ".config/Proton"
    ];
  };
}
