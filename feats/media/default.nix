{
  flake.nixosModules.media = { pkgs, ... }: {
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
