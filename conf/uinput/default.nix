{globals, ...}: {
  hardware.uinput = {
    enable = true;
  };

  users.groups = {
    input.members = [globals.username];
    uinput.members = [globals.username];
  };
}
