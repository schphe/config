{
  flake.nixosModules.document = { pkgs, ... }: {
    home-manager.users.schphe = {
      home.packages = with pkgs; [
        libreoffice
        pandoc
        tinymist
        typst
        typstyle
      ];

      programs.zathura.enable = true;

      xdg.mimeApps.defaultApplications =
        let
          zathura = [ "org.pwmt.zathura.desktop" ];
          writer = [ "writer.desktop" ];
          calc = [ "calc.desktop" ];
          impress = [ "impress.desktop" ];
        in
        {
          "application/pdf" = zathura;
          "application/epub+zip" = zathura;
          "image/vnd.djvu" = zathura;
          "application/postscript" = zathura;

          "application/msword" = writer;
          "application/rtf" = writer;
          "application/vnd.oasis.opendocument.text" = writer;
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = writer;

          "application/vnd.ms-excel" = calc;
          "application/vnd.oasis.opendocument.spreadsheet" = calc;
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = calc;
          "text/csv" = calc;

          "application/vnd.ms-powerpoint" = impress;
          "application/vnd.oasis.opendocument.presentation" = impress;
          "application/vnd.openxmlformats-officedocument.presentationml.presentation" = impress;
        };
    };
  };
}
