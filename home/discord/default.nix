{...}: {
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
    };
  };
}
