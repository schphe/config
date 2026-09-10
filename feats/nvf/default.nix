{ inputs, ... }:

{
  flake.nixosModules.nvf = {
    home-manager.users.schphe = {
      imports = [ inputs.nvf.homeManagerModules.default ];
      stylix.targets.nvf.plugin = "mini-base16";
      programs.nvf = {
        enable = true;
        settings.vim = {
          viAlias = true;
          vimAlias = true;
          lsp = {
            enable = true;
            formatOnSave = true;
          };
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            bash.enable = true;
            docker.enable = true;
            json.enable = true;
            markdown.enable = true;
            nix = {
              enable = true;
              format.type = [ "nixfmt" ];
              lsp.servers = [ "nixd" ];
            };
            typst.enable = true;
            yaml.enable = true;
          };
          options = {
            number = true;
            relativenumber = true;
          };
        };
      };
    };
  };
}
