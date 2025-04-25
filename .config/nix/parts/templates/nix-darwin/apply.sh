#!/bin/sh

SCRIPT_PATH=$(dirname $(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")"))

copy_nix_config() {
  mkdir -p ~/.config/nix
  cp nix.conf ~/.config/nix/
  sudo dscl . append /Groups/nix-bld GroupMembership $USER
}

install_nix() {
  # This one courtesy of:
  # https://github.com/shadowrylander/shadowrylander/blob/35bb51822c46578d0a5da5810263fa85d464043c/.config/yadm/bootstrap#L56
  install_nix_bin() {
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install

    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      # shellcheck source=/dev/null
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  }
  command -v nix >/dev/null 2>&1 || install_nix_bin
}

configure_nix() {
  system_type=$(uname -s)

  if [ "$system_type" = "Darwin" ]; then
    nix run nix-darwin -- switch --flake "${SCRIPT_PATH}"
    sudo xcodebuild -license accept
  fi
  nix run 'nixpkgs#home-manager' -- switch -b orig --flake "${SCRIPT_PATH}"
}

install_nix
copy_nix_config
configure_nix
