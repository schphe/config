{globals, pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    tilt

    ffmpeg
    p7zip
  ];

  programs = {
    nushell = {
      enable = true;

      extraConfig = ''
        $env.config = {
          show_banner: false

          completions: {
            algorithm: "fuzzy"
            case_sensitive: false
            partial: true
            quick: true
          }
        }

        $env.PATH = (
          $env.PATH |
          split row (char esep) |
          append /usr/bin/env
        )
      '';
    };

    bat = {
      enable = true;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
    };

    fzf = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;

      settings = {
        add_newline = false;

        character = {
          error_symbol = "[❯](bold red)";
          success_symbol = "[❯](bold green)";
        };
      };
    };
  };

  home.persistence."/pers/home/${globals.username}" = {
    files = [
      ".config/nushell/history.txt"
      ".local/share/db.zo"
    ];
  };
}
