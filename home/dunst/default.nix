{...}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        frame_width = 4;
        offset="10x10";
      };
    };
  };
}
