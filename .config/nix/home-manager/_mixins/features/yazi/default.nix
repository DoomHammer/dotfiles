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
  dir = "${flakePath config}/home-manager/_mixins/features/yazi";
in
{
  home.packages = with pkgs; [
    yazi

    unar # Handle archives
    mediainfo # Display media information
    exiftool # Read EXIF metadata
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  xdg.configFile."yazi.toml".source = config.lib.file.mkOutOfStoreSymlink "${dir}/yazi-config/yazi.toml";
}
