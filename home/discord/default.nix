{globals, ...}: {
  imports = [
    ./style.nix
  ];

  programs.nixcord = {
    enable = true;

    discord = {
      enable = false;
    };

    vesktop = {
      enable = true;
    };

    config = {
      plugins = {
        gifPaste = {
          enable = true;
        };

        fakeNitro = {
          enable = true;
        };

        fixCodeblockGap = {
          enable = true;
        };

        fixYoutubeEmbeds = {
          enable = true;
        };

        youtubeAdblock = {
          enable = true;
        };
      };

      useQuickCss = true;
    };
  };

  home.persistence."/pers/home/${globals.username}" = {
    directories = [
      ".config/vesktop"
    ];
  };
}
