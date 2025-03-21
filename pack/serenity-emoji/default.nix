{lib, stdenv, ...}: stdenv.mkDerivation {
  name = "serenity-emoji";
  version = "0.1";

  src = ./serenity-emoji.ttf;

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 --target $out/share/fonts/truetype $src
    runHook postInstall
  '';

  meta = with lib; {
    description = "serenityos emoji font";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
