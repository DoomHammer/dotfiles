{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cmake
    conan
    ninja
  ];
}
