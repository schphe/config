{
  flake.nixosModules.memory = {
    zramSwap = {
      enable = true;
      memoryPercent = 100;
      priority = 100;
    };

    systemd.oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
    };
  };
}
