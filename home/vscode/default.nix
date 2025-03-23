{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.main = {
      #extensions = with pkgs.vscode-extensions; [
      #];
    };
  };

  stylix.targets.vscode = {
    profileNames = [
      "main"
    ];
  };
}
