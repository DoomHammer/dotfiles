# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  bk = pkgs.callPackage ./bk { };
  backblaze-downloader = pkgs.callPackage ./backblaze-downloader { };
  camtasia2019 = pkgs.callPackage ./camtasia2019 { };
  cricut-design-space = pkgs.callPackage ./cricut-design-space { };
  signal = pkgs.callPackage ./signal { };
}
