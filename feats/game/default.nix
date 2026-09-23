{
  flake.nixosModules.game =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      mcpelauncher = pkgs.mcpelauncher-ui-qt.override {
        mcpelauncher-client = pkgs.mcpelauncher-client.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./symbols.patch ];
        });
      };
    in
    {
      environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
        "/persist".users.schphe.directories = [
          ".config/mcpelauncher-ui-qt"
          ".local/share/mcpelauncher"
          ".local/share/PrismLauncher"
        ];
      };

      home-manager.users.schphe.home.packages = [
        mcpelauncher
        pkgs.prismlauncher
      ];
    };
}
