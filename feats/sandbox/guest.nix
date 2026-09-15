{ lib, pkgs, ... }:

let
  guestLauncher = pkgs.writeShellApplication {
    name = "sandbox-guest";
    runtimeInputs = with pkgs; [
      bash
      coreutils
      util-linux
    ];
    text = ''
      set -o errexit -o nounset -o pipefail

      mkdir -p /work/app
      cp -a --no-preserve=ownership /input/app/. /work/app/
      chmod -R u+rwX /work/app
      cd /work/app

      status=0
      bash /input/command || status=$?
      sudo systemctl poweroff
      exit "$status"
    '';
  };
in
{
  networking = {
    hostName = "unsafe-gui";
    useDHCP = false;
    firewall.enable = true;
  };

  fileSystems."/input" = {
    device = "/dev/vdb";
    fsType = "squashfs";
    options = [
      "ro"
      "nodev"
      "nosuid"
    ];
  };

  boot = {
    initrd.availableKernelModules = [
      "squashfs"
      "virtio_blk"
      "virtio_gpu"
      "virtio_pci"
    ];
    kernelParams = [ "console=ttyAMA0" ];
  };

  users.users.sandbox = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "video" ];
  };

  services.cage = {
    enable = true;
    user = "sandbox";
    program = "${guestLauncher}/bin/sandbox-guest";
  };

  security.sudo.extraRules = [
    {
      users = [ "sandbox" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl poweroff";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      at-spi2-atk
      cairo
      dbus
      expat
      fontconfig
      freetype
      glib
      gtk3
      libdrm
      libglvnd
      libxkbcommon
      mesa
      nspr
      nss
      pango
      stdenv.cc.cc
      systemd
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
    ];
  };

  environment = {
    systemPackages = [ pkgs.sudo ];
    variables = {
      LIBGL_ALWAYS_SOFTWARE = "1";
      GALLIUM_DRIVER = "llvmpipe";
    };
  };

  documentation.enable = false;
  services.openssh.enable = false;
  system.stateVersion = "26.11";

  image.modules.qemu-efi = {
    image.baseName = lib.mkForce "unsafe-gui";
    virtualisation.diskSize = 8192;
  };
}
