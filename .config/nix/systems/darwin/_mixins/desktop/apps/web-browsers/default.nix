{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    inputs.glide-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
