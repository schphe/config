{...}: {
  programs.kitty = {
    enable = true;

    settings = {
      confirm_os_window_close = 0;
    };
  };

  services.xremap.config.keymap = [{
    name = "open kitty";

    remap = {
      super-enter = {
        launch = ["kitty"];
      };
    };
  }];
}
