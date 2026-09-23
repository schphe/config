{
  flake.nixosModules.media = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".users.schphe.directories = [
        ".config/kdenlive"
        ".config/krita"
        ".config/obs-studio"
        ".local/share/kdenlive"
        ".local/share/krita"
      ];
    };

    home-manager.users.schphe = {
      home.packages = with pkgs; [
        imv
        kdePackages.kdenlive
        krita
        obs-studio
        yt-dlp
      ];

      programs.mpv.enable = true;

      xdg.mimeApps.defaultApplications = {
        "image/gif" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
      };
    };
  };
}
