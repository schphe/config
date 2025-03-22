{globals, pkgs, ...}: {
  home.packages = [
    pkgs.impala
  ];

  services.xremap.config.keymap = [{
    name = "open impala";

    remap = {
      super-v = {
        launch = [globals.terminal "impala"];
      };
    };
  }];
}
