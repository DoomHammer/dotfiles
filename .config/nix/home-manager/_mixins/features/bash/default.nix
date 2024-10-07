{
  config,
  flakePath,
  pkgs,
  ...
}:
let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/_mixins/features/bash";
in
{
  home.packages = with pkgs; [
    bashInteractive
    eza
  ];
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      . $HOME/.bashrc.prev
    '';
    shellAliases = {
      tree = "${pkgs.eza}/bin/eza --tree";
    };
  };
  home.file = {
    ".bash_logout".source = config.lib.file.mkOutOfStoreSymlink "${dir}/bash-config/bash_logout";
    ".bashrc.prev".source = config.lib.file.mkOutOfStoreSymlink "${dir}/bash-config/bashrc";
  };
}
