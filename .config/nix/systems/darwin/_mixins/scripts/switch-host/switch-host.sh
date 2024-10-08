#!/usr/bin/env bash

if [ -e "${HOME}/.config/nix" ]; then
  all_cores=$(sysctl -n hw.logicalcpu)
  build_cores=$(printf "%.0f" "$(echo "${all_cores} * 0.75" | bc)")
  echo "Switch nix-darwin ❄️ with ${build_cores} cores"
  nix run nix-darwin -- switch --flake "${HOME}/.config/nix" --cores "${build_cores}" -L
else
  echo "ERROR! No nix-config found in ${HOME}/.config/nix"
fi
