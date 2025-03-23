{assets, pkgs, ...}: {
  boot.plymouth = {
    enable = true;
  };

  stylix.targets.plymouth = {
    logo = assets.none;
    logoAnimated = false;
  };
}
