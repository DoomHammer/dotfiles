{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
{
  zsh-sensible = stdenvNoCC.mkDerivation rec {
    pname = "zsh-sensible";
    version = "c0fc54b924a29cfa773996df9755ed71e371a382";

    src = fetchFromGitHub {
      owner = "oconnor663";
      repo = "zsh-sensible";
      rev = version;
      sha256 = "sha256-2DUQlp0pTxac872WwQqefiiFWOx+rUnlmtwykaF0T7E=";
    };

    strictDeps = true;
    installPhase = ''
      install -D sensible.zsh $out/share/zsh-sensible/zsh-sensible.plugin.zsh
    '';

    meta = with lib; {
      description = "zsh defaults that everyone can agree on";
      homepage = "https://github.com/oconnor663/zsh-sensible";
      # license = licenses.mit;
      platforms = platforms.unix;
    };
  };
}
