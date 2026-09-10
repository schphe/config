{
  flake.nixosModules.battery = { pkgs, ... }: {
    powerManagement.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    systemd.services.asahi-charge-limit = {
      description = "Set the Asahi battery charge limit";
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathExists = "/sys/class/power_supply/macsmc-battery/charge_control_end_threshold";
      serviceConfig.Type = "oneshot";
      script = ''
        echo 75 > /sys/class/power_supply/macsmc-battery/charge_control_start_threshold
        echo 80 > /sys/class/power_supply/macsmc-battery/charge_control_end_threshold
      '';
    };
  };
}
