{globals, pkgs, ...}: {
  home.packages = [
    pkgs.bluetui
  ];

  services.xremap.config.keymap = [{
    name = "open bluetui";

    remap = {
      super-b = {
        launch = [globals.terminal "bluetui"];
      };
    };
  }];
}
