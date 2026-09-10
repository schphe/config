{
  flake.nixosModules.reverse = { pkgs, ... }: {
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
