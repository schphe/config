{
  flake.nixosModules.secret = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
      "/persist" = {
        directories = [ "/var/lib/sops-nix" ];
        users.schphe.directories = [ ".config/sops" ];
      };
    };

    sops = {
      age.keyFile = "/persist/var/lib/sops-nix/key.txt";
      secrets."BerkeleyMonoVariable.ttf" = {
        sopsFile = ../../vault/system/BerkeleyMonoVariable.ttf.enc.yaml;
        format = "binary";
        owner = "schphe";
        group = "users";
        mode = "0444";
      };
      secrets.noctalia-calendar-url = {
        sopsFile = ../../vault/system/noctalia-calendar.enc.yaml;
        key = "url";
        owner = "schphe";
        group = "users";
        mode = "0400";
      };
    };

    users.users.schphe.extraGroups = [ "keys" ];

    environment.systemPackages = with pkgs; [
      age
      secretspec
      sops
    ];
  };
}
