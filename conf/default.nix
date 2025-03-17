{inputs, globals, modules-home, utils...}: {
  imports = (utils.importDirs ./.);

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];

    substituters = [];

    trusted-public-keys = [];

    trusted-users = [
      "@wheel"
      "root"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  home-manager = {
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs;
      inherit globals;
    };

    sharedModules = [{
      imports = modules-home;
    }];
  };

  users.users.${globals.username} = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
    ];
  };
}
