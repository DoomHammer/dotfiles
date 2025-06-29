{
  lib,
  stdenv,
  fetchurl,
  undmg,
  makeWrapper,
  autoPatchelfHook,
  pango,
  gtk3,
  glibc,
  alsa-lib,
}:

let
  myZenVersion = "1.13.2b";
  x86_64-darwin-hash = "";
  aarch64-darwin-hash = "sha256-6u6vGta8cvnC0oKd8Aq6scAyHGRqi39cKBDzpifBOa8=";
  x86_64-linux-hash = "";
  sources = {
    x86_64-darwin = fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/${myZenVersion}/zen.macos-universal.dmg";
      sha256 = x86_64-darwin-hash;
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/${myZenVersion}/zen.macos-universal.dmg";
      sha256 = aarch64-darwin-hash;
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/${myZenVersion}/zen.linux-generic.tar.bz2";
      sha256 = x86_64-linux-hash;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zen-browser";
  version = "${myZenVersion}";

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  dontUnpack = stdenv.isDarwin;
  unpackPhase = ''
    mkdir -p $out
    tar xjvf ${finalAttrs.src} -C $out
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
    stdenv.cc.cc.lib
    pango
    gtk3
    glibc
    alsa-lib
  ];
  buildInputs = [ makeWrapper ] ++ lib.optionals stdenv.isDarwin [ undmg ];

  buildPhase =
    let
      app_name = "Zen";
    in
    if stdenv.isDarwin then
      ''
        undmg ${finalAttrs.src}
        mkdir -p $out/bin
        cp -r "${app_name}.app" $out
        makeWrapper "$out/${app_name}.app/Contents/MacOS/zen" "$out/bin/zen"
      ''
    else
      ''
        mkdir -p $out/bin
        makeWrapper "$out/zen/zen-bin" "$out/bin/zen"
      '';
})
