{
  flake.nixosModules.agent = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
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
