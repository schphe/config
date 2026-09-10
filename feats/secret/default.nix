{
  flake.nixosModules.secret = { pkgs, ... }: {
    sops = {
      age.keyFile = "/var/lib/sops-nix/key.txt";
      secrets.berkeley-mono-font = {
        sopsFile = ../../vault/system/BerkeleyMonoVariable.ttf.enc.yaml;
        format = "binary";
        path = "/run/secrets/BerkeleyMonoVariable.ttf";
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

    environment.systemPackages = with pkgs; [
      age
      secretspec
      sops
    ];
  };
}
