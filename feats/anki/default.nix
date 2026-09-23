{
  flake.nixosModules.anki = { config, lib, ... }: {
    environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".users.schphe.directories = [ ".local/share/Anki2" ];
    };

    home-manager.users.schphe.programs.anki = {
      enable = true;
      theme = "dark";
    };
  };
}
