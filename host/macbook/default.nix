{...}: {
  imports = [
    ./hardware.nix
  ];

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "loglevel=3"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
    ];

    loader = {
      efi.canTouchEfiVariables = false;
      systemd-boot.enable = true;
      timeout = 1;
    };
  };

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ./firmware;

      useExperimentalGPUDriver = true;
      setupAsahiSound = true;
      withRust = true;      
    };

    graphics = {
      enable = true;
      enable32Bit = false;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  networking = {
    hostName = "macbook";
  };

  time.timeZone = "America/Chicago";

  system.stateVersion = "24.11";
}
