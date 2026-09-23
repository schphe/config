{
  flake.nixosModules.reverse =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.persistence = lib.mkIf (config.fileSystems ? "/persist") {
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
