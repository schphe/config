{
  flake.nixosModules.direnv = {
    home-manager.users.schphe.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
