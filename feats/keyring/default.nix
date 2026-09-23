{
  flake.nixosModules.keyring =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
        "/persist".users.schphe.directories = [ ".local/share/keyrings" ];
      };

      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;
      environment.systemPackages = [ pkgs.libsecret ];
    };
}
