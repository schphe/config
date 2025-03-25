{inputs, pkgs, ...}: {
  programs.anyrun = {
    enable = true;

    config = {
      plugins = with pkgs.inputs.anyrun; [
        applications
        translate
        rink
      ] ++ [
        pkgs.inputs.anyrun-cliphist.cliphist
      ];

      hideIcons = true;
    };

    extraCss = ''
      * {
        border-radius: 0px;
        border-width: 4px;
      }
    '';
  };

  services.xremap.config.keymap = [{
    name = "open anyrun";

    remap = {
      super-space = {
        launch = ["anyrun"];
      };
    };
  }];
}
