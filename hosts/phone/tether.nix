{
  config,
  lib,
  pkgs,
  ...
}:
let
  address = "172.16.42.1";
  serial = config.hardware.xiaomi-surya.serial.enable;
  ip = lib.getExe' pkgs.iproute2 "ip";
  rm = lib.getExe' pkgs.coreutils "rm";
  teardown = pkgs.writeShellScript "usb-tethering-teardown" ''
    g=/sys/kernel/config/usb_gadget/g1
    [ -d "$g" ] || exit 0

    echo "" > "$g/UDC" 2>/dev/null || true
    ${rm} -f "$g"/configs/c.1/*.usb0
    rmdir "$g"/configs/c.1/strings/0x409 "$g"/configs/c.1
    rmdir "$g"/functions/* "$g"/strings/0x409
    rmdir "$g"
  '';
in
{
  fileSystems."/sys/kernel/config" = {
    device = "none";
    fsType = "configfs";
  };

  boot.kernelModules = [ "libcomposite" ];

  networking.networkmanager.unmanaged = [ "interface-name:usb0" ];

  systemd.services.usb-tethering = {
    description = "USB network gadget";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = teardown;
    };

    script = ''
      CONFIGFS=/sys/kernel/config/usb_gadget

      if ! [ -e "$CONFIGFS" ]; then
        echo "$CONFIGFS does not exist; is libcomposite loaded?" >&2
        exit 1
      fi

      mkdir -p "$CONFIGFS/g1"
      cd "$CONFIGFS/g1"

      echo 0x1F3A > idVendor
      echo 0xEFE8 > idProduct

      mkdir -p strings/0x409
      echo "Xiaomi" > strings/0x409/manufacturer
      echo "POCO X3 NFC" > strings/0x409/product
      echo "${config.networking.hostName}" > strings/0x409/serialnumber

      mkdir -p configs/c.1/strings/0x409
      echo "NCM" > configs/c.1/strings/0x409/configuration

      mkdir -p functions/ncm.usb0
      ln -sfn "$CONFIGFS/g1/functions/ncm.usb0" configs/c.1/ncm.usb0

      ${lib.optionalString serial ''
        mkdir -p functions/acm.usb0
        ln -sfn "$CONFIGFS/g1/functions/acm.usb0" configs/c.1/acm.usb0
      ''}

      for _ in $(seq 30); do
        [ -n "$(ls /sys/class/udc 2>/dev/null)" ] && break
        sleep 1
      done

      if [ -z "$(ls /sys/class/udc 2>/dev/null)" ]; then
        echo "No USB Device Controller available" >&2
        exit 1
      fi

      if [ "$(wc -w < UDC)" -gt 0 ]; then
        echo "" > UDC
      fi
      ls /sys/class/udc | head -1 > UDC

      ${ip} address add ${address}/24 dev usb0 || true
      ${ip} link set usb0 up
    '';
  };

  systemd.network = {
    enable = true;
    networks.usb0 = {
      address = [ "${address}/24" ];
      matchConfig.Name = "usb0";
      networkConfig.DHCPServer = "yes";
      dhcpServerConfig = {
        PoolOffset = 10;
        PoolSize = 100;
        EmitDNS = "no";
        EmitRouter = "no";
      };
    };
  };
}
