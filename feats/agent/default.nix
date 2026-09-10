{
  flake.nixosModules.agent = { pkgs, ... }: {
    home-manager.users.schphe.home.packages = with pkgs; [
      claude-code
      codex
    ];
  };
}
