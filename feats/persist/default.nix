{
  flake.nixosModules.persist =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # every feat declares the paths it owns behind this same guard, so a host
      # without a /persist filesystem inherits none of them
      config = lib.mkIf (config.fileSystems ? "/persist") {
        environment.persistence."/persist" = {
          hideMounts = true;
          allowTrash = true;

          directories = [
            "/var/lib/nixos"
            "/var/log"
          ];
          files = [ "/etc/machine-id" ];

          users.schphe = {
            directories = [
              "nixos"

              {
                directory = ".gnupg";
                mode = "0700";
              }
              {
                directory = ".ssh";
                mode = "0700";
              }
            ];
          };
        };

        boot.initrd.systemd.services.rollback = {
          description = "Restore blank Btrfs root and home subvolumes";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-cryptsetup@cryptroot.service" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          path = [
            pkgs.btrfs-progs
            pkgs.util-linux
          ];
          script = ''
            set -eu
            mkdir -p /btrfs_tmp
            mount -t btrfs -o subvol=/ /dev/mapper/cryptroot /btrfs_tmp
            trap 'umount /btrfs_tmp' EXIT

            label="$(btrfs filesystem label /btrfs_tmp)"
            if [ "$label" != "nixos" ]; then
              echo "Refusing rollback: expected Btrfs label nixos, got $label" >&2
              exit 1
            fi

            test -d /btrfs_tmp/@root-blank
            test -d /btrfs_tmp/@root
            btrfs subvolume delete /btrfs_tmp/@root
            btrfs subvolume snapshot /btrfs_tmp/@root-blank /btrfs_tmp/@root

            test -d /btrfs_tmp/@home-blank
            test -d /btrfs_tmp/@home
            btrfs subvolume delete /btrfs_tmp/@home
            btrfs subvolume snapshot /btrfs_tmp/@home-blank /btrfs_tmp/@home
          '';
        };
      };
    };
}
