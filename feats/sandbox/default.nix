{ inputs, ... }:

{
  flake =
    let
      guest = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./guest.nix ];
      };
    in
    {
      nixosConfigurations.unsafe-gui = guest;

      nixosModules.sandbox =
        { pkgs, ... }:
        let
          image = guest.config.system.build.images.qemu-efi;
          imagePath = "${image}/${image.passthru.filePath}";

          unsafeGui = pkgs.writeShellApplication {
            name = "unsafe-gui";
            runtimeInputs = with pkgs; [
              bubblewrap
              coreutils
              findutils
              gnused
              libnotify
              procps
              qemu_kvm
              squashfsTools
              virt-viewer
            ];
            text = ''
              set -o errexit -o nounset -o pipefail

              usage() {
                echo "usage: unsafe-gui DIRECTORY EXECUTABLE [ARG ...]" >&2
                echo "EXECUTABLE must be a path relative to DIRECTORY" >&2
              }

              if [ "$#" -lt 2 ]; then
                usage
                exit 2
              fi

              source_dir=$(realpath -- "$1")
              executable=$2
              shift 2

              if [ ! -d "$source_dir" ]; then
                echo "unsafe-gui: not a directory: $source_dir" >&2
                exit 2
              fi

              case "$executable" in
                /*|../*|*/../*|*/..|..)
                  echo "unsafe-gui: EXECUTABLE must remain inside DIRECTORY" >&2
                  exit 2
                  ;;
              esac

              if [ ! -f "$source_dir/$executable" ]; then
                echo "unsafe-gui: executable not found: $source_dir/$executable" >&2
                exit 2
              fi

              if find -L "$source_dir" -type l -print -quit | grep -q .; then
                echo "unsafe-gui: refusing dangling or cyclic symbolic links" >&2
                exit 2
              fi

              if find "$source_dir" \( -type b -o -type c -o -type p -o -type s \) -print -quit | grep -q .; then
                echo "unsafe-gui: refusing device nodes, FIFOs, or sockets" >&2
                exit 2
              fi

              run_dir=$(mktemp -d --tmpdir unsafe-gui.XXXXXXXX)
              qemu_pid=""
              viewer_pid=""
              cleanup() {
                if [ -n "$viewer_pid" ]; then kill "$viewer_pid" 2>/dev/null || true; fi
                if [ -n "$qemu_pid" ]; then kill "$qemu_pid" 2>/dev/null || true; fi
                rm -rf -- "$run_dir"
              }
              trap cleanup EXIT INT TERM HUP

              mkdir "$run_dir/stage"
              cp -a --reflink=auto -- "$source_dir" "$run_dir/stage/app"
              find "$run_dir/stage/app" -type f -perm /6000 -exec chmod u-s,g-s {} +

              {
                printf 'exec '
                printf '%q ' "./$executable" "$@"
                printf '\n'
              } > "$run_dir/stage/command"
              chmod 0500 "$run_dir/stage/command"

              mksquashfs "$run_dir/stage" "$run_dir/input.squashfs" \
                -all-root -noappend -no-progress -quiet -no-xattrs
              rm -rf -- "$run_dir/stage"

              socket="$run_dir/display.sock"
              firmware="${pkgs.qemu_kvm}/share/qemu/edk2-aarch64-code.fd"

              bwrap \
                --unshare-all \
                --die-with-parent \
                --new-session \
                --ro-bind /nix/store /nix/store \
                --bind "$run_dir" "$run_dir" \
                --dev /dev \
                --dev-bind /dev/kvm /dev/kvm \
                --proc /proc \
                --tmpfs /tmp \
                --chdir "$run_dir" \
                ${pkgs.qemu_kvm}/bin/qemu-system-aarch64 \
                  -name unsafe-gui \
                  -machine virt,accel=kvm,gic-version=3 \
                  -cpu host \
                  -smp 4 \
                  -m 4096 \
                  -nodefaults \
                  -no-user-config \
                  -rtc base=utc \
                  -bios "$firmware" \
                  -drive file=${imagePath},if=none,id=system,format=qcow2,snapshot=on \
                  -device virtio-blk-pci,drive=system \
                  -drive file="$run_dir/input.squashfs",if=none,id=input,format=raw,readonly=on \
                  -device virtio-blk-pci,drive=input \
                  -device virtio-gpu-pci \
                  -device qemu-xhci \
                  -device usb-kbd \
                  -device usb-tablet \
                  -nic none \
                  -serial none \
                  -monitor none \
                  -display none \
                  -vnc "unix:$socket" &
              qemu_pid=$!

              for _ in $(seq 1 200); do
                [ -S "$socket" ] && break
                kill -0 "$qemu_pid" 2>/dev/null || {
                  wait "$qemu_pid"
                  exit $?
                }
                sleep 0.05
              done

              if [ ! -S "$socket" ]; then
                echo "unsafe-gui: VM display did not become ready" >&2
                exit 1
              fi

              remote-viewer "vnc+unix://$socket" &
              viewer_pid=$!
              wait "$qemu_pid"
            '';
          };
        in
        {
          environment.systemPackages = [ unsafeGui ];
          users.groups.kvm = { };
          users.users.schphe.extraGroups = [ "kvm" ];
        };
    };
}
