{
  fetchFromGitHub,
  lib,
  installShellFiles,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "bk";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "aeosynth";
    repo = "bk";
    rev = "v${version}";
    sha256 = "sha256-Z3lBL1bPc6uEfyMr4sNI77SF4dES3QxDkaFjxnA0oc8=";
  };

  cargoHash = "sha256-pE5loMwNMdHL3GODiw3kVVHj374hf3+vIDEYTqvx5WI=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  meta = with lib; {
    description = "Terminal Epub reader";
    homepage = "https://github.com/aeosynth/bk";
    license = licenses.mit;
    mainProgram = "bk";
    # maintainers = lib.maintainers.doomhammer;
  };
}
