{
  flake.nixosModules.persist =
    { pkgs, ... }:
    {
      environment.persistence."/persist" = {
        hideMounts = true;
        allowTrash = true;
        directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/bluetooth"
          "/var/lib/containers"
          "/var/lib/iwd"
          "/var/lib/nixos"
          "/var/lib/sops-nix"
          "/var/log"
        ];
        files = [ "/etc/machine-id" ];

        users = {
          schphe = {
            directories = [
              "desktop"
              "documents"
              "downloads"
              "music"
              "pictures"
              "projects"
              "public"
              "templates"
              "videos"
              "nixos"

              {
                directory = ".gnupg";
                mode = "0700";
              }
              {
                directory = ".ssh";
                mode = "0700";
              }

              ".claude"
              ".codex"
              ".kube"
              ".config/gh"
              ".config/sops"
              ".config/kdeconnect"
              ".config/kdenlive"
              ".config/krita"
              ".config/libreoffice"
              ".config/mcpelauncher-ui-qt"
              ".config/net.imput.helium"
              ".config/noctalia"
              ".config/obs-studio"
              ".config/protonmail"
              ".config/rizin"
              ".config/RizinOrg"
              ".config/Thunar"
              ".config/xfce4"
              ".config/thunderbird"
              ".config/Vencord"
              ".config/vesktop"
              ".config/wireshark"
              ".config/zed"

              ".local/share/Anki2"
              ".local/share/containers"
              ".local/share/direnv"
              ".local/share/fcitx5/mozc"
              ".local/share/kdeconnect"
              ".local/share/kdenlive"
              ".local/share/keyrings"
              ".local/share/krita"
              ".local/share/localsend_app"
              ".local/share/mcpelauncher"
              ".local/share/oxidezap"
              ".local/share/PrismLauncher"
              ".local/share/protonmail"
              ".local/share/rizin"
              ".local/share/zed"
              ".local/state/concord"
              ".local/state/noctalia"

              ".wine"
            ];
            files = [
              ".bash_history"
              ".claude.json"
              ".zsh_history"
              ".config/trashrc"
              ".local/share/recently-used.xbel"
              ".local/share/user-places.xbel"
            ];
          };
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
}
