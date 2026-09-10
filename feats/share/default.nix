{ inputs, ... }:

{
  flake.nixosModules.share = {
    programs.kdeconnect.enable = true;

    programs.localsend = {
      enable = true;
      openFirewall = true;

      package = inputs.nixpkgs.legacyPackages.x86_64-linux.localsend;
    };
  };
}
