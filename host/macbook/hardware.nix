{lib, ...}: {
  boot = {
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [];

      kernelModules = [
        "dm-snapshot"
      ];
    };

    kernelModules = [];
  };

  boot.initrd = {
    luks.devices = {
      "encrypted" = {
        #allowDiscards = true;
        device = "/dev/disk/by-uuid/484eece9-1273-48ee-b3d5-769506dde2fa";
        preLVM = true;
      };
    };

    postResumeCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/volume-group/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/B22E-0B12";
      fsType = "vfat";

      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  
    "/" = {
      device = "/dev/volume-group/root";
      fsType = "btrfs";

      options = [
        "subvol=root"
        #"discard" ?
        #"defaults" ?
      ];
    };
    
    "/pers" = {
      device = "/dev/volume-group/root";
      fsType = "btrfs";

      neededForBoot = true;

      options = [
        "subvol=pers"
      ];
    };

    "/nix" = {
      device = "/dev/volume-group/root";
      fsType = "btrfs";

      options = [
        "subvol=nix"
      ];
    };
  };

  swapDevices = [{
    device = "/dev/volume-group/swap";
  }];

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
