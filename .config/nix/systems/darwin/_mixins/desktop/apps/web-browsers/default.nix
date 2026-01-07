{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    # glide-browser
    inputs.glide-browser.packages.aarch64-darwin.glide-browser
    # FIXME: This shouldn't be hardcoded
    inputs.zen-browser.packages.aarch64-darwin.default
  ];
}
