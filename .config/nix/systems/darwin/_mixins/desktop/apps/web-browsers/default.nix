{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
