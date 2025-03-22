{pkgs, ...}: {
  services.cliphist = {
    enable = true;
  };

  home.packages = [
    pkgs.wl-clipboard
  ];

  services.xremap.config.keymap = [{
    name = "wipe clipboard";

    remap = {
      super-shift-c = {
        launch = ["cliphist" "wipe"];
      };
    };
  }];
}
