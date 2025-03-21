{globals, pkgs, ...}: {
  users.users.${globals.username} = {
    shell = pkgs.nushell;
  };

  security.sudo = {
    wheelNeedsPassword = false;
  };
}
