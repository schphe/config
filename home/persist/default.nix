{globals, ...}: {
  home.persistence."/pers/home/${globals.username}" = {
    allowOther = true;
  
    directories = [
      # "document"
      "download"
      "project"
    ];

    files = [];
  };
}
