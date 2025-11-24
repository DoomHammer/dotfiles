{
  lib,
  requireFile,
  stdenvNoCC,
  ...
}:
let
  appname = "Cricut Design Space";
  version = "9.43.60";
in
stdenvNoCC.mkDerivation rec {
  pname = "cricut-design-space";
  inherit version;

  src = requireFile {
    name = "CricutDesignSpace-Install-v${version}.dmg";
    url = "https://design.cricut.com/";
    sha256 = "0wchn8jg93vahf0gd8i1i75r4bv4wiv06p2gfv0qmg77lgb1mfsf";
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
    description = "Cricut Design Space";
    homepage = "https://design.cricut.com/";
    # license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
