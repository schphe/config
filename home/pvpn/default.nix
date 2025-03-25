{globals, pkgs, ...}: {
  home.packages = [
    pkgs.protonvpn-cli_2
  ];

  home.persistence."/pers/home/${globals.username}" = {
    directories = [
      ".pvpn-cli"
    ];
  };
}
