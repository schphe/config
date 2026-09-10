{
  flake.nixosModules.upkeep =
    { pkgs, ... }:
    let
      upgradeSystem = pkgs.writeShellApplication {
        name = "upgrade-system";
        runtimeInputs = with pkgs; [
          btrfs-progs
          coreutils
          nh
        ];
        text = ''
          timestamp="$(date --utc +%Y%m%dT%H%M%SZ)"
          snapshot="/.snapshots/root-pre-upgrade-$timestamp"
          sudo btrfs subvolume snapshot -r / "$snapshot"
          echo "Created $snapshot"
          nh os switch --update "$@"
        '';
      };
    in
    {
      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };
      };

      programs.nh = {
        enable = true;
        flake = "/home/schphe/nixos";
      };

      environment.systemPackages = [
        pkgs.nix-tree
        pkgs.nixfmt
        pkgs.nvd
        upgradeSystem
      ];
    };
}
