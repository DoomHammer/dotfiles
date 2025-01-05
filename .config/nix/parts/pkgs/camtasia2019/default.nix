{
  lib,
  fetchurl,
  stdenvNoCC,
  undmg,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "camtasia";
  version = "19.0.11";

  src = fetchurl {
    url = "https://download.techsmith.com/camtasiamac/releases/19011/Camtasia.dmg";
    hash = "sha256-rUWsBJmPZ08iyeFzS0vlVgM7HIxdxlzj5emFULBsbdI=";
  };

  nativeBuildInputs = [
    undmg
  ];

  sourceRoot = ".";
  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv *.app $out/Applications/
  '';

  meta = {
    description = "Camtasia 2019";
    homepage = "https://www.techsmith.com/camtasia/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
