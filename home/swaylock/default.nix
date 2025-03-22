{lib, pkgs, ...}: {
  programs.swaylock = {
    enable = true;
  };

  services.swayidle = let
    lock = "${pkgs.swaylock}/bin/swaylock -fu";
  in {
    enable = true;

    events = [
      {
        event = "before-sleep";
        command = lock;
      }
      {
        event = "lock";
        command = lock;
      }
    ];

    timeouts = [{
      timeout = 300;
      command = lock;
    }];
  };
}
