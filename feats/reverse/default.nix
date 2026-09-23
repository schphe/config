{
  flake.nixosModules.reverse = { config, pkgs, ... }: {
    environment.persistence = pkgs.lib.mkIf (config.fileSystems ? "/persist") {
      "/persist".users.schphe.directories = [
        ".config/rizin"
        ".config/RizinOrg"
        ".local/share/rizin"
      ];
    };

    home-manager.users.schphe.home.packages = with pkgs; [
      binwalk
      gdb
      hexyl
      lldb
      rizin
      valgrind
      (cutter.withPlugins (plugins: [ plugins.rz-ghidra ]))
    ];
  };
}
