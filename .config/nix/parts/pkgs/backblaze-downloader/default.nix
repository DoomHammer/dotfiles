{
  lib,
  fetchzip,
  stdenvNoCC,
  undmg,
  unzip,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "backblaze-downloader";
  version = "9.1.0.818";

  src = fetchzip {
    url = "https://secure.backblaze.com/mac_restore_downloader";
    extension = "zip";
    # This one changes often
    hash = "sha256-B96hwZbRWVv0YsDR6lhu0ynfmxQ7bJMcK1vCVLXZ1ZI=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    unzip
    undmg
  ];

  sourceRoot = ".";

  installPhase = ''
    undmg ./source/*.dmg
    mkdir -p $out/Applications
    mv *.app $out/Applications/
  '';

  meta = {
    description = "Backblaze downloader";
    homepage = "https://www.backblaze.com/";
    # license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
