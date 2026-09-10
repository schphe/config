{
  flake.nixosModules.game =
    { pkgs, ... }:
    let
      mcpelauncher = pkgs.mcpelauncher-ui-qt.override {
        mcpelauncher-client = pkgs.mcpelauncher-client.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./symbols.patch ];
        });
      };
    in
    {
      home-manager.users.schphe.home.packages = [
        mcpelauncher
        pkgs.prismlauncher
      ];
    };
}
