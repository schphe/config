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
        "network"
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

      network = {
        format-disconnected = "";
        format-wifi = "{signalStrength}%";
        tooltip-format = "{essid}\n{gwaddr}";
      };

      pulseaudio = {};

      battery = {
        format-time = "{H}h{M}m";
        tooltip-format = "{time}";
      };
    };
  };
}
