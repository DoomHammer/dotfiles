{
  lib,
  fetchurl,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "camtasia";
  version = "19.0.11";

  appname = "Camtasia 2019";

  src = fetchurl {
    url = "https://download.techsmith.com/camtasiamac/releases/19011/Camtasia.dmg";
    hash = "sha256-rUWsBJmPZ08iyeFzS0vlVgM7HIxdxlzj5emFULBsbdI=";
  };

  unpackCmd = ''
    echo "File to unpack: $curSrc"
    if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
    mnt=$(mktemp -d -t ci-XXXXXXXXXX)

    function finish {
      echo "Detaching $mnt"
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }

    trap finish EXIT

    echo "Attaching $mnt"

    /usr/bin/hdiutil attach -nobrowse -readonly $src -mountpoint $mnt

    echo "What's in the mount dir"?
    ls -la $mnt/

    echo "Copying contents"
    shopt -s extglob
    DEST="$PWD"
    (cd "$mnt"; cp -a !(Applications) "$DEST/")

    echo "What's in the dest dir"?
    ls -la $DEST/
  '';
  phases = [
    "unpackPhase"
    "installPhase"
  ];

  sourceRoot = "${appname}.app";

  installPhase = ''
    mkdir -p "$out/Applications/${appname}.app"
    cp -a ./. "$out/Applications/${appname}.app/"
  ''; # '';
  dontFixup = true;

  meta = {
    description = "Camtasia 2019";
    homepage = "https://www.techsmith.com/camtasia/";
    # license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
