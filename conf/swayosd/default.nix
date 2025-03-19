{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.swayosd
  ];
  
  services.udev.packages = [
    pkgs.swayosd
  ];

  systemd.services.swayosd-libinput-backend = {
      description = "swayosd libinput backend";
      
      documentation = [
        "https://github.com/erikreider/swayosd"
      ];
      
      wantedBy = ["graphical.target"];
      partOf = ["graphical.target"];
      after = ["graphical.target"];

      serviceConfig = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
        Restart = "on-failure";
      };
    };
}
