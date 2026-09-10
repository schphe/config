{
  flake.nixosModules.network = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      bandwhich
      dnsutils
      ethtool
      tcpdump
      nmap
    ];
  };
}
