{...}: {
  programs = {
    thunar.enable = true;
    xfconf.enable = true;
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
