{
  flake.nixosModules.discord =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home-manager.users.schphe.home.packages = [ pkgs.concord-tui ];

      home-manager.users.schphe.programs.vesktop = {
        enable = true;
        vencord = {
          settings = {
            autoUpdate = false;
            autoUpdateNotification = false;
            notifyAboutUpdates = false;
          };
          themes.stylix = lib.mkAfter ''
            .theme-light,
            .theme-dark,
            .theme-darker,
            .theme-midnight,
            .visual-refresh {
              --bg-brand: var(--base0D) !important;
              --blurple-50: var(--base0D) !important;
              --brand-500: var(--base0D) !important;
              --control-brand-foreground: var(--base0D) !important;
              --header-primary: var(--base06) !important;
              --interactive-active: var(--base06) !important;
              --interactive-hover: var(--base06) !important;
              --interactive-normal: var(--base06) !important;
              --text-brand: var(--base0D) !important;
              --text-default: var(--base06) !important;
              --text-link: var(--base0D) !important;
              --text-normal: var(--base06) !important;
              --text-primary: var(--base06) !important;
              --textbox-markdown-syntax: var(--base06) !important;
            }

            .checked__87bf1 {
              background-color: var(--base0D) !important;
            }

            .visual-refresh path[fill^="rgba(88, 101, 242, 1)"] {
              fill: var(--base0D) !important;
            }

            * {
              font-family: "Berkeley Mono Variable", monospace !important;
              font-size: 14px !important;
            }
          '';
        };
      };
    };
}
