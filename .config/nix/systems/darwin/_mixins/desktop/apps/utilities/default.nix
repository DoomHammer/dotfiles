{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    grandperspective
    unstable.utm
  ];
}
