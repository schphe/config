{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
    };
  };

  stylix.targets.vscode = {
    profileNames = [
      "default"
    ];
  };
}
