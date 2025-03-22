{...}: {
  programs = {
    git = {
      enable = true;

      userEmail = "git@emin.sh";
      userName = "schphe";
    };

    git-credential-oauth = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };
  };
}
