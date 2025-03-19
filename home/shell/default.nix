{pkgs, ...}: {
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

    carapace = {
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
}
