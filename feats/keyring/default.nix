{
  flake.nixosModules.keyring = { pkgs, ... }: {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    environment.systemPackages = [ pkgs.libsecret ];
  };
}
