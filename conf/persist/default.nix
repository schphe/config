{...}: {
  environment.persistence."/pers" = {
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
    ];

    files = [];
  };
}
