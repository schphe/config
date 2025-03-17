{
  importDirs = dir: builtins.attrValues (
    builtins.mapAttrs (n: _: "${dir}/${n}") (
      builtins.filterAttrs (n: t: t == "directory") (
       builtins.readDir dir
  )));
}
