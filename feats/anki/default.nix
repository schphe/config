{
  flake.nixosModules.anki = {
    home-manager.users.schphe.programs.anki = {
      enable = true;
      theme = "dark";
    };
  };
}
