{
  flake.nixosModules.shell =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        git
        jq
        pciutils
        ripgrep
        usbutils
      ];

      home-manager.users.schphe = { lib, ... }: {
        home.packages = with pkgs; [
          comma
          duf
          difftastic
          dust
          eza
          fd
          ffmpeg
          gh
          hyperfine
          imagemagick
          jq
          just
          lsof
          ltrace
          p7zip
          ripgrep
          rsync
          shellcheck
          shfmt
          sops
          strace
          tlrc
          unzip
          watchexec
          wget
          yq-go
          zip
        ];
        programs = {
          bat.enable = true;
          helix.enable = true;
          btop.enable = true;
          carapace = {
            enable = true;
            environment.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
            extraPackages = with pkgs; [
              bash
              fish
              inshellisense
              zsh
            ];
          };
          delta = {
            enable = true;
            enableGitIntegration = true;
          };
          fzf = {
            enable = true;
            historyWidget.command = "";
          };
          git = {
            enable = true;
            settings = {
              user = {
                name = "schphe";
                email = "git@emin.sh";
              };
              credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
              credential."https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
            };
          };
          atuin = {
            enable = true;
            flags = [ "--disable-up-arrow" ];
          };
          lazygit.enable = true;
          nix-index.enable = true;
          starship = {
            enable = true;
          };
          zoxide = {
            enable = true;
          };
          zsh = {
            enable = true;
            autosuggestion.enable = true;
            initContent = lib.mkOrder 550 ''
              zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
              zstyle ':completion:*:git:*' group-order \
                'main commands' 'alias commands' 'external commands'
            '';
          };
        };
      };
    };
}
