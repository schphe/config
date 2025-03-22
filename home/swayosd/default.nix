{config, pkgs, ...}: {
  services.swayosd = {
    enable = true;

    stylePath = ./style.css;
  };

  services.xremap.config.keymap = [{
    name = "swayosd triggers";

    remap = let
      cli = "swayosd-client";
    in {
      brightnessdown = {
        launch = [cli "--brightness=lower"];
      };

      brightnessup = {
        launch = [cli "--brightness=raise"];
      };

      volumedown = {
        launch = [cli "--output-volume=lower"];
      };

      volumeup = {
        launch = [cli "--output-volume=raise"];
      };

      mute = {
        launch = [cli "--output-volume=mute-toggle"];
      };
    };
  }];
}
