{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zen-browser
  ];

  homebrew = {
    casks = [ "firefox" ];
  };
}
