{inputs, pkgs, ...}: {
  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        translate
        rink
      ] ++ [
        inputs.anyrun-cliphist.packages.${pkgs.system}.cliphist
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
