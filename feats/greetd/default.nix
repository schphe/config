{
  flake.nixosModules.greetd = {
    programs.noctalia-greeter = {
      enable = true;
      settings = {
        keyboard.layout = "tr";
        session.default = "niri";
        user.default = "schphe";
      };
    };
  };
}
