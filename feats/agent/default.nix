{
  flake.nixosModules.agent =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
        "/persist".users.schphe = {
          directories = [
            ".claude"
            ".codex"
          ];
          files = [ ".claude.json" ];
        };
      };

      home-manager.users.schphe.home.packages = with pkgs; [
        claude-code
        codex
        rtk
      ];
    };
}
