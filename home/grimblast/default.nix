{pkgs, ...}: {
  home.packages = [
    pkgs.grimblast
  ];

  services.xremap.config.keymap = [{
    name = "grimblast triggers";

    remap = {
      super-s = {
        launch = ["grimblast" "copy" "screen"];
      };

      super-ctrl-s = {
        launch = ["grimblast" "save" "screen"];
      };

      super-shift-s = {
        launch = ["grimblast" "copy" "area"];
      };

      super-ctrl-shift-s = {
        launch = ["grimblast" "save" "area"];
      };
    };
  }];
}
