{...}: {
  environment.persistence."/pers" = {
    hideMounts = true;

    directories = [
      "/var/lib/bluetooth"
      "/var/lib/iwd"
      "/var/lib/nixos"
    ];

    files = []; 
  };
}
