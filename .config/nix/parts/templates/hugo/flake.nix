{
  description = "A basic Hugo flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/29dcf702b10d258b9bcd56bd38667c329614e128";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs;
      {
        packages.website = pkgs.stdenv.mkDerivation {
          name = "basic-hugo";
          src = self;
          buildPhase = "npm i; ${pkgs.hugo}/bin/hugo";
          installPhase = "cp -r public $out";
        };
        defaultPackage = self.packages.${system}.website;
        devShells.default = mkShell {
          buildInputs = [
            hugo
            nodejs
            nodePackages.npm
          ];
        };
      }
    );
}
