{ pkgs, ... }:
{
  home.packages = with pkgs; [
    atuin
    bash-preexec
    blesh
  ];
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      inline_height = 30;
      show_preview = true;
      show_help = true;
      history_filter = [
        "^bg\w*$"
        "^fg\w*$"
        "^jobs\w*$"
        "^ls\w*$"
        "^cd \\.\\.\w*$"
        "^cd -\w*$"
        "^cd\w*$"
        "^pwd\w*$"
        "^exit\w*$"
        "^pushd\w*$"
        "^popd\w*$"
        "^dirs\w*$"
        "^.*AWS_.*KEY.*$"
        "^.*AWS_.*TOKEN.*$"
      ];
      secrets_filter = true;
    };
  };
}
