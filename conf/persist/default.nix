{...}: {
  environment.persistence."/pers" = {
    hideMounts = true;

    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
    ];

    files = [];
  };
}
