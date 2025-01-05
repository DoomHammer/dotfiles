{
  lib,
  fetchurl,
  stdenvNoCC,
  _7zz,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "signal";
  version = "7.39.0";

  src = fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-adhoc-20241213-a970d647c-mac-universal-7.39.0-adhoc.20241213.15-a970d647c.dmg";
    hash = "sha256-tvJdcBJBPLQTsdJo1/aRfU6bMuZt8/99fo3RHzfG5pk=";
  };

  nativeBuildInputs = [
    _7zz
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    mv *.app $out/Applications/
  '';

  meta = {
    description = "Signal";
    homepage = "https://signalusers.org";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
