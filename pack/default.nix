{pkgs ? import <nixpkgs> {}, ...}: rec {
  serenity-emoji = pkgs.callPackage ./serenity-emoji {};
}
