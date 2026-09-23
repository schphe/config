{
  flake.nixosModules.network = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/iwd"
      ];
    };

    environment.systemPackages = with pkgs; [
      bandwhich
      dnsutils
      ethtool
      tcpdump
      nmap
    ];
  };
}
