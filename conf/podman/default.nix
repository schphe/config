{pkgs, ...}: {
  virtualisation = {
    containers = {
      enable = true;
    };

    podman = {
      enable = true;
      dockerCompat = true;

      defaultNetwork = {
        settings = {
          dns_enabled = true;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
    podman-tui
    dive
  ];
}
