{ pkgs, ... }:

{
  home.packages = with pkgs; [ vscodium ];
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.extensions
}
