{lib, ...}: {
  boot = {
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [
        "usb_storage"
      ];

      kernelModules = [
        "dm-snapshot"
      ];
    };

    kernelModules = [];
  };

  boot.luks.devices = {
    "encrypted" = {
      allowDiscards = true;
      device = "/dev/disk/by-uuid/6679451e-5c2e-4c52-b7d9-20990fac00ea";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/845ca5be-bfe2-4478-89b4-0809aeedb9bb";
      fsType = "btrfs";

      options = [
        "subvol=root"
        "discard"
        "defaults"
      ];
    };
    
    "/boot" = {
      device = "/dev/disk/by-uuid/3A37-1DED";
      fsType = "vfat";

      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/845ca5be-bfe2-4478-89b4-0809aeedb9bb";
      fsType = "btrfs";

      options = [
        "subvol=home"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/845ca5be-bfe2-4478-89b4-0809aeedb9bb";
      fsType = "btrfs";

      options = [
        "subvol=nix"
      ];
    };
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/59c25a7b-da33-449c-b332-0618ade63354";
  }];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
