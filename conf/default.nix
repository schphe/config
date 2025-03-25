{config, globals, utilities, ...}: {
  imports = (utilities.importDirs ./.);

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];

    substituters = [
      "https://cache.nixos.org"
      "https://cache.garnix.io"
      "https://anyrun.cachix.org"
    ];

    trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
    ];

    trusted-users = [
      "@wheel"
      "root"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  sops.secrets = {
    ${globals.username} = {
      neededForUsers = true;
    };
  };

  users.users.${globals.username} = let
    password = config.sops.secrets.${globals.username};
  in {
    hashedPasswordFile = password.path;
    isNormalUser = true;

    extraGroups = [
      "wheel"
    ];
  };
}
