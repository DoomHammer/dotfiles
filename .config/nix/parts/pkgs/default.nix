# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  backblaze-downloader = pkgs.callPackage ./backblaze-downloader { };
  brother-printer-driver = pkgs.callPackage ./brother-printer-driver { };
  camtasia2019 = pkgs.callPackage ./camtasia2019 { };
  cricut-design-space = pkgs.callPackage ./cricut-design-space { };
  linn-konfig = pkgs.callPackage ./linn-konfig { };
}
