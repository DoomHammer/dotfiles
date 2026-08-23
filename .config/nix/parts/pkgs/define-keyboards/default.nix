{
  stdenvNoCC,
  writeTextFile,
  zsh,
  ...
}:
let
  name = builtins.baseNameOf (builtins.toString ./.);
  shellApplication = writeTextFile {
    inherit name;
    executable = true;
    destination = "/bin/${name}";
    allowSubstitutes = true;
    preferLocalBuild = false;
    text = ''
      #! ${zsh}/bin/zsh
    ''
    + builtins.readFile ./${name}.zsh;
  };
in
stdenvNoCC.mkDerivation {
  inherit name;

  dontUnpack = true;

  installPhase = ''
    cp -R ${shellApplication} $out
  '';
}
