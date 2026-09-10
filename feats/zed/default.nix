{
  flake.nixosModules.zed =
    { pkgs, ... }:
    {
      home-manager.users.schphe.programs.zed-editor = {
        enable = true;
        extraPackages = [ pkgs.nixd ];
        extensions = [
          "dockerfile"
          "nix"
          "typst"
        ];
        userSettings = {
          active_pane_modifiers = {
            border_size = 1.0;
            inactive_opacity = 1.0;
          };
          autosave = "on_focus_change";
          load_direnv = "direct";
          vim_mode = false;
          window_decorations = "server";

          languages.Nix = {
            language_servers = [ "nixd" ];
            formatter.external = {
              command = "nixfmt";
              arguments = [ "-" ];
            };
            format_on_save = "on";
          };

          lsp.nixd.settings = {
            nixpkgs.expr = "import (builtins.getFlake \"/home/schphe/nixos\").inputs.nixpkgs { }";
            options = {
              nixos.expr = "(builtins.getFlake \"/home/schphe/nixos\").nixosConfigurations.macbook.options";
              home-manager.expr = "(builtins.getFlake \"/home/schphe/nixos\").nixosConfigurations.macbook.options.home-manager.users.type.getSubOptions []";
            };
          };
        };
      };
    };
}
