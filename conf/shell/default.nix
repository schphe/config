{globals, pkgs, ...}: {
  users.users.${globals.username} = {
    shell = pkgs.nushell;
  };
}
