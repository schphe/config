{
  disko.devices.disk.cryptroot = {
    type = "disk";
    device = "/dev/disk/by-partuuid/57197322-f6ff-4265-ba53-89e3bcfdae84";
    content = {
      type = "luks";
      name = "cryptroot";
      settings.allowDiscards = true;
      content = {
        type = "btrfs";
        extraArgs = [
          "-L"
          "nixos"
        ];
        subvolumes = {
          "@root" = {
            mountpoint = "/";
            mountOptions = [
              "compress=zstd:3"
              "noatime"
            ];
          };
          "@nix" = {
            mountpoint = "/nix";
            mountOptions = [
              "compress=zstd:3"
              "noatime"
            ];
          };
          "@home" = {
            mountpoint = "/home";
            mountOptions = [
              "compress=zstd:3"
              "noatime"
            ];
          };
          "@persist" = {
            mountpoint = "/persist";
            mountOptions = [
              "compress=zstd:3"
              "noatime"
            ];
          };
          "@snapshots" = {
            mountpoint = "/.snapshots";
            mountOptions = [
              "compress=zstd:3"
              "noatime"
            ];
          };
        };
      };
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/66ac92a7-e88e-43ea-a314-1a363170889b";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
}
