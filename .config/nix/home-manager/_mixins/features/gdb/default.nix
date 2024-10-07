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
  dir = "${flakePath config}/home-manager/_mixins/features/gdb";
in
{
  home.packages = with pkgs; [ gdb ];
  home.file.".gdbinit".source = config.lib.file.mkOutOfStoreSymlink "${dir}/gdb-config/gdbinit";
}
