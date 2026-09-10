{
  flake.nixosModules.wireshark = { pkgs, ... }: {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.users.schphe.extraGroups = [ "wireshark" ];
  };
}
