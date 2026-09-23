{ config, lib, ... }:

{
  environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
    "/persist".directories = [ "/var/lib/bluetooth" ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = false;
  };

  hardware.asahi.enable = true;
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  services.fwupd.enable = false;
}
