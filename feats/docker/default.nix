{
  flake.nixosModules.docker = { pkgs, ... }: {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        live-restore = false;
        log-driver = "json-file";
        log-opts = {
          max-size = "100m";
          max-file = "3";
        };
      };
    };

    boot.kernelModules = [
      "br_netfilter"
      "ip_vs"
      "ip_vs_rr"
      "overlay"
    ];

    users.users.schphe.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
    ];
  };
}
