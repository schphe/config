{
  flake.nixosModules.wireshark = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".users.schphe.directories = [ ".config/wireshark" ];
    };

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.users.schphe.extraGroups = [ "wireshark" ];
  };
}
