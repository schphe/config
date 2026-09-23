{
  flake.nixosModules.direnv = { config, lib, ... }: {
    environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".users.schphe.directories = [ ".local/share/direnv" ];
    };

    home-manager.users.schphe.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
