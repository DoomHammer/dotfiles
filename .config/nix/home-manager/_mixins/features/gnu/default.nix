{
  config,
  flakePath,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    coreutils
    gnumake
    gnused
  ];
}
