{globals, pkgs, ...}: {
  networking = {
    networkmanager = {
      enable = true;

      wifi = {
        backend = "iwd";
      };
    };

    wireless.iwd = {
      enable = true;

      settings = {
        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "network";
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
}
