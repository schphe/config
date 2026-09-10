{ inputs, ... }:
{
  flake.nixosModules.plasma =
    { pkgs, ... }:
    {
      services.desktopManager.plasma6.enable = true;

      services.displayManager = {
        sddm = {
          enable = true;
          wayland = {
            enable = true;
            compositor = "kwin";
          };
        };
        sessionPackages = [ pkgs.kdePackages.plasma-mobile ];
        defaultSession = "plasma-mobile";
        autoLogin = {
          enable = true;
          user = "schphe";
        };
      };

      programs.kde-pim.enable = false;
      services.orca.enable = false;

      environment.systemPackages = with pkgs.kdePackages; [
        plasma-mobile
        plasma-keyboard
        plasma-settings
        qmlkonsole
      ];

      home-manager.sharedModules = [ inputs.plasma.homeModules.plasma-manager ];

      home-manager.users.schphe.programs.plasma = {
        enable = true;
        configFile.kwinrc.Wayland.InputMethod = "${pkgs.kdePackages.plasma-keyboard}/share/applications/org.kde.plasma.keyboard.desktop";
      };
    };
}
