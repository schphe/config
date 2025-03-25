{globals, lib, pkgs, ...}: {
  networking = {
    firewall = {
      checkReversePath = "loose";
    };

    networkmanager = {
      enable = true;

      wifi = {
        backend = "iwd";
      };
    };

    wireless.iwd = {
      enable = true;

      settings = {
        Settings = {
          AlwaysRandomizeAddress = true;
        };
      };
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
      "/var/lib/bluetooth"
      "/var/lib/iwd"
    ];
  };
}
