{
  lib,
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  xar,
  cpio,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "linn-konfig";
  version = "4.37.175";

  src = fetchurl {
    url = "https://cloud.linn.co.uk/applications/konfig/releases/Davaar/konfig_latest_osx.pkg";
    hash = "sha256-SYKurlZq1fz8iBZETog7mNmCIbL9mDNysS4Qu8OaDVE=";
  };

  nativeBuildInputs = [
    makeWrapper
    xar
    cpio
  ];

  unpackPhase = ''
    xar -xf $src
    zcat < uk.co.linn.Konfig.pkg/Payload | cpio -i
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Konfig.app $out/Applications/
    runHook postInstall
  '';

  meta = {
    description = "Linn Konfig";
    homepage = "https://radio.linn.co.uk/software";
    # license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
