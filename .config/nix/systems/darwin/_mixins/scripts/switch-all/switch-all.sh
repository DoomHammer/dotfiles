#!/usr/bin/env bash

# if nh-home is in the PATH then use it
if command -v nh-home &>/dev/null; then
  nh-home switch
else
  nix run nixpkgs#home-manager -- switch -b hm-orig --flake "$HOME/.config/nix" -L
fi
switch-host
