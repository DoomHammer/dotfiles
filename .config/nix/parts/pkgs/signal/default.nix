{
  lib,
  fetchurl,
  stdenvNoCC,
  _7zz,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "signal";
  version = "7.63.0";

  src = fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.63.0.dmg";
    hash = "sha256-OKJPCXw8Gv9cpzQsA3R3jTblUVTcXa4a/wVHXrEdCVM=";
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
    # license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
