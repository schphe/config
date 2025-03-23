{config, pkgs, ...}: {
  programs.doom-emacs = {
    enable = true;
    doomDir = ./.;

    emacs = pkgs.emacs-pgtk;

    extraPackages = epkgs: let
      emacs = config.programs.emacs;
      extra = emacs.extraPackages epkgs;
    in extra ++ [
      (epkgs.trivialBuild {
        pname = "stylix-theme";
        version = "0.1.0";
        packageRequires = extra;

        src = pkgs.writeText "stylix-theme.el" emacs.extraConfig;
      })
    ];
  };
}
