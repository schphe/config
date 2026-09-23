{
  flake.nixosModules.tailscale = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".directories = [ "/var/lib/tailscale" ];
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ 41641 ];
    };

    environment.systemPackages = [ pkgs.tailscale ];
  };
}
