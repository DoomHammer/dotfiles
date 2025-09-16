{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    # FIXME: This shouldn't be hardcoded
    inputs.zen-browser.packages.aarch64-darwin.default
  ];
}
