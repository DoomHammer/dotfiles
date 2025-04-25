#!/bin/sh

HOSTNAME="$(hostname -s)"

sed -i -e "s/user@machine/$USER@$HOSTNAME/" flake.nix
sed -i -e 's/"machine" = helper.mkDarwin { hostname = "machine"; };/"'"$HOSTNAME"'" = helper.mkDarwin { hostname = "'"$HOSTNAME"'"; };/' flake.nix
sed -i -e "s/\$USER/$USER/" parts/lib/helpers.nix
sed -i -e "s/\$USER/$USER/" systems/darwin/default.nix
mv "systems/darwin/machine" "systems/darwin/$HOSTNAME"
