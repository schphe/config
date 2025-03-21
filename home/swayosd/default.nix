{config, pkgs, ...}: let
  cli = "swayosd-client";
in {
  services.swayosd = {
    enable = true;

    stylePath = ./style.css;
  };

  services.xremap.config.keymap = [
    {
      name = "swayosd triggers";

      remap = {
        brightnessdown = {
          launch = [cli "--brightness=lower"];
        };

        brightnessup = {
          launch = [cli "--brightness=raise"];
        };

        mute = {
          launch = [cli "--output-volume=mute-toggle"];
        };

        volumedown = {
          launch = [cli "--output-volume=lower"];
        };

        volumeup = {
          launch = [cli "--output-volume=raise"];
        };
      };
    }
  ];
}
