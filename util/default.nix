lib: {
  importDirs = path: lib.lists.filter (x: x != null) (
    lib.attrsets.mapAttrsToList 
      (name: type: 
        if type == "directory" 
        then path + "/${name}" 
        else null
      ) 
      (builtins.readDir path)
  );
}
