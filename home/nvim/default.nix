{...}: {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        lsp = {
          enable = true;
        };

        viAlias = false;
        vimAlias = true;
      };
    };
  };
}
