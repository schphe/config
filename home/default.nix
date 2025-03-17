{globals, utils, ...}: {
  imports = (utils.importDirs ./.);

  home = {
    inherit globals.username;
    homeDirectory = "/home/${globals.username}";
  };

  programs.home-manager = {
    enable = true;
  };

  home.stateVersion = "24.11";
}
