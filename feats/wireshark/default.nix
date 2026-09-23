{
  flake.nixosModules.wireshark =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
        "/persist".users.schphe.directories = [ ".config/wireshark" ];
      };

      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark;
      };

      users.users.schphe.extraGroups = [ "wireshark" ];
    };
}
