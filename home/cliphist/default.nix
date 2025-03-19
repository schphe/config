{...}: {
  services.cliphist = {
    enable = true;
  };

  services.xremap.config.keymap = [
    {
      name = "wipe clipboard";

      remap = {
        super-shift-c = {
          launch = ["cliphist" "wipe"];
        };
      };
    }
  ];
}
