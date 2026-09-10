{ inputs, ... }:

{
  flake.nixosModules.compat =
    { pkgs, ... }:
    let
      x86 = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      guestInit = pkgs.writeShellScript "fexrun-init" ''
        ln -snf ${x86.mesa} /run/opengl-driver
        ln -snf ${x86.pkgsi686Linux.mesa} /run/opengl-driver-32
      '';

      fexInterpreter = pkgs.runCommand "fex-interpreter" { } ''
        mkdir -p $out/bin
        ln -s ${pkgs.fex}/bin/FEX $out/bin/FEXInterpreter
      '';

      fexrun = pkgs.writeShellScriptBin "fexrun" ''
        export PATH="${fexInterpreter}/bin:${pkgs.fex}/bin:$PATH"

        tty=""
        [ -t 1 ] && tty="-t"

        export FEXRUN_CWD="$PWD"

        env_args=""
        for name in FEXRUN_CWD HOME USER LANG XDG_RUNTIME_DIR XDG_SESSION_TYPE \
                    WAYLAND_DISPLAY DISPLAY LD_PRELOAD LD_LIBRARY_PATH \
                    LIBGL_ALWAYS_SOFTWARE MESA_LOADER_DRIVER_OVERRIDE \
                    ''${FEXRUN_ENV-}; do
          if [ -n "''${!name-}" ]; then
            env_args="$env_args -e $name"
          fi
        done

        gpu=""
        [ -n "''${FEXRUN_GPU_MODE-}" ] && gpu="--gpu-mode=$FEXRUN_GPU_MODE"

        exec ${pkgs.muvm}/bin/muvm \
          --emu=fex \
          $gpu \
          -x ${guestInit} \
          $env_args \
          -i $tty -- ${pkgs.bash}/bin/bash -c 'cd "$FEXRUN_CWD" || exit 1; exec "$@"' fexrun "$@"
      '';

      x86run = pkgs.writeShellScriptBin "x86run" ''
        exec ${fexrun}/bin/fexrun ${x86.steam-run-free}/bin/steam-run "$@"
      '';

      winerun = pkgs.writeShellScriptBin "winerun" ''
        export FEXRUN_ENV="''${FEXRUN_ENV-} WINEPREFIX WINEARCH WINEDEBUG WINEDLLOVERRIDES WINEFSYNC DXVK_HUD"
        exec ${fexrun}/bin/fexrun ${x86.wineWow64Packages.stable}/bin/wine "$@"
      '';
    in
    {
      boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

      programs.nix-ld.enable = true;

      home-manager.users.schphe.home.file.".fex-emu/Config.json".text = builtins.toJSON {
        Config.RootFS = "/";
      };

      environment.systemPackages = [
        fexInterpreter
        fexrun
        pkgs.fex
        pkgs.muvm
        winerun
        x86run
      ];
    };
}
