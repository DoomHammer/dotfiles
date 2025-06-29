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
  dir = "${flakePath config}/home-manager/_mixins/features/docker";
in
{
  home.packages = with pkgs; [
    colima
    docker
  ];

  home.sessionVariables = {
    COLIMA_HOME = "$HOME/.config/colima";
  };

  xdg.configFile."colima/default/colima.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/colima-config/default/colima.yaml";
  programs.ssh.extraConfig = ''
    Include ${config.home.homeDirectory}/.config/colima/ssh_config
  '';
}
