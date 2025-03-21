{self, nixpkgs, ...}@inputs: let
  lib = nixpkgs.lib;
in rec {
  ################  global ################
  flattenAttrs = path: set: builtins.foldl' (acc: name:
    let
      value = set.${name};
      newPath = path ++ [ name ];
    in
      if builtins.isAttrs value
      then acc // flattenAttrs newPath value
      else acc // { "${builtins.concatStringsSep "." newPath}" = value; }
  ) {} (builtins.attrNames set);

  importDirs = path: lib.lists.filter (x: x != null) (
    lib.attrsets.mapAttrsToList 
      (name: type: 
        if type == "directory" 
        then path + "/${name}" 
        else null
      ) 
      (builtins.readDir path)
  );

  ################ flake ################
  newHost = host: system: args: mod: home: extra: let
    specialArgs = args // {
      packages = self.packages.${system};
    };
  in lib.nixosSystem {
    modules = mod ++ extra ++ [host] ++ [../conf] ++ [({...}: {
      home-manager = {
        backupFileExtension = "backup";
        extraSpecialArgs = specialArgs;

        users.${args.globals.username} = {
          imports = home ++ [../home];
        };
      };
    })];

    inherit specialArgs;
    inherit system;
  };

  packages = forEachSystem (system:
    import ../pack {
      pkgs = import nixpkgs {
        inherit system;
      };
    }
  );

  forEachSystem = lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
  ];
}
