{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    grandperspective
    utm
  ];

  homebrew = {
    casks = [ "balenaetcher" ];
  };
}
