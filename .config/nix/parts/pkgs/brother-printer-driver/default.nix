{
  lib,
  fetchurl,
  stdenvNoCC,
  undmg,
  xar,
  cpio,
  ...
}:
stdenvNoCC.mkDerivation rec {
  # FIXME
  pname = "brother-printer-driver";
  version = "1.5.0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105521/Brother_PrinterDrivers_MonochromeLaser_1_5_0.dmg";
    sha256 = "sha256-zNBaD/d7UWFIeAsPqsPklcw4pok/hQpBfw2CdXcPslM=";
  };

  nativeBuildInputs = [
    undmg
    xar
    cpio
  ];

  unpackPhase = ''
    undmg $src

    mv *.pkg ${pname}.pkg
    xar -xf *.pkg

    zcat < */Payload | cpio -i
    ls -lR
  '';

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Library/Printers
    mv Library/Printers/* $out/Library/Printers/
  '';

  meta = {
    description = "Brother Printer Driver";
    homepage = "https://www.brother.pl/support/hl1210we/downloads";
    # license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
