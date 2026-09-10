{
  flake.nixosModules.vpn = { pkgs, ... }: {
    home-manager.users.schphe.home.packages = [ pkgs.proton-vpn ];
  };
}
