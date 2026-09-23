{ inputs, ... }:

{
  flake.nixosModules.share = { config, lib, ... }: {
    environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".users.schphe.directories = [
        ".config/kdeconnect"
        ".local/share/kdeconnect"
        ".local/share/localsend_app"
      ];
    };

    programs.kdeconnect.enable = true;

    programs.localsend = {
      enable = true;
      openFirewall = true;

      package = inputs.nixpkgs.legacyPackages.x86_64-linux.localsend;
    };
  };
}
