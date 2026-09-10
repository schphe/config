{
  flake.nixosModules.devenv = { pkgs, ... }: {
    home-manager.users.schphe.home.packages = [ pkgs.devenv ];
  };
}
