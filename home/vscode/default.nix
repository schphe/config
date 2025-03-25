{pkgs, utilities, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
      ];

      userSettings = utilities.flattenAttrs [] {
        window = {
          customMenuBarAltFocus = false;
          menuBarVisibility = "toggle";
          titleBarStyle = "native";
        };
      };
    };
  };

  stylix.targets.vscode = {
    profileNames = [
      "default"
    ];
  };
}
