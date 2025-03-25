{pkgs, ...}: {
  sops = {
    age = {
      keyFile = "/pers/var/lib/sops-nix/key.txt";
    };

    defaultSopsFile = ./secret.yaml;
  };

  environment = {
    sessionVariables = {
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
    };

    systemPackages = with pkgs; [
      sops
    ];
  };

  environment.persistence."/pers" = {
    directories = [
      "/var/lib/sops-nix"
    ];
  };
}
