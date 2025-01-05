{
  lib,
  fetchurl,
  stdenvNoCC,
  undmg,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "cricut-design-space";
  version = "8.60.67";

  src = fetchurl {
    url = "https://staticcontent.cricut.com/a/software/osx-native/CricutDesignSpace-Install-v8.60.67.dmg?Expires=1735396184&Signature=aA8j9xqNhHOgfc4F80c--RPlR2tvAbGLTprYDe1H~rNxfIvqQ6qnxlWX0~ZDNmF~h88XcIH-WFlveZYhflkTE8O1P-1JNOl-Ban2IZLaBeYRKPH9KArteJ-YXm9p1m91R9nFNMECMbIs1ETS7kHBRaa2x5JKMduoXCuKhzAMNquC~BcqoKl0Gjmjyl54S8LlQh3vmYOev3x~Vn3umiU2L3M687q~MwdgtQLn7z0e9ktlDNV5oUW8mZNT~oABAVOiSvtmLwLi1EjGc-Bpago6ztEIbsuX-7~HgUOZ4XJm7wA5HPO66D~wJUAb8TrQIbZlniqg2gBur9jHhpCMQniDVg__&Key-Pair-Id=K2W1AJ47IQWIOI";
    hash = "sha256-rin0AjxCNQuhSIZ/FkM1yQW6KPIWFAFQx/y1e9dSn2c=";
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
    description = "Cricut Design Space";
    homepage = "https://design.cricut.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
