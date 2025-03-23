{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];

    profiles.default = {
    };
  };

  stylix.targets.vscode = {
    profileNames = [
      "default"
    ];
  };
}
