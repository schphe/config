{...}: {
  imports = [
    ./style.nix
  ];

  programs.waybar = {
    enable = true;

    settings.main = {
      height = 5;

      layer = "bottom";
      position = "top";

      modules-left = [
        "hyprland/workspaces"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "network#vpn"
        "network#wifi"
        "pulseaudio"
        "battery"
      ];

      "hyprland/workspaces" = {
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
      };

      clock = {
        tooltip = true;
        tooltip-format = "{:%d/%m/%y}";
      };

      "network#vpn" = {
        interface = "proton0";
        format = "";
        format-disconnected = "*";
        tooltip = false;
      };

      "network#wifi" = {
        interface = "wlan0";
        format-linked = "";
        format-ethernet = "";
        format-disconnected = "";
        format-wifi = "{signalStrength}%";
        tooltip-format = "{essid}";
      };

      pulseaudio = {};

      battery = {
        format-time = "{H}h{M}m";
        tooltip-format = "{time}";
      };
    };
  };
}
