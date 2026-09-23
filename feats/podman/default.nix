{
  flake.nixosModules.podman = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
      "/persist" = {
        directories = [ "/var/lib/containers" ];
        users.schphe.directories = [ ".local/share/containers" ];
      };
    };

    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
    };
    environment.systemPackages = [ pkgs.podman-compose ];
  };
}
