{
  flake.nixosModules.disk = { pkgs, ... }: {
    services = {
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" ];
      };
      fstrim.enable = true;
      smartd = {
        enable = true;
        autodetect = true;
      };
    };

    environment.systemPackages = with pkgs; [
      btrfs-progs
      cryptsetup
      gptfdisk
      nvme-cli
      smartmontools
    ];
  };
}
