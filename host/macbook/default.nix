{assets, ...}: {
  imports = [
    ./hardware.nix
  ];

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "udev.log_priority=3"
    ];

    loader = {
      efi.canTouchEfiVariables = false;
      systemd-boot.enable = true;
      timeout = 0;
    };

    m1n1CustomLogo = assets.boot;
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

  console = {
    keyMap = "trq";
  };

  networking = {
    hostName = "macbook";
  };

  time.timeZone = "America/Chicago";

  system.stateVersion = "24.11";
}
