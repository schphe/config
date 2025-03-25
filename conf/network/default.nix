{globals, lib, pkgs, ...}: {
  networking = {
    firewall = {
      checkReversePath = "loose";
    };

    networkmanager = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanager
    iw
  ];

  users.users.${globals.username} = {
    extraGroups = [
      "networkmanager"
    ];
  };

  environment.persistence."/pers" = {
    directories = [
      "/etc/NetworkManager"
      "/var/lib/bluetooth"
    ];
  };
}
