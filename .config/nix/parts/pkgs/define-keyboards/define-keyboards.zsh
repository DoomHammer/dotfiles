#!/bin/zsh
# DefineKeyboards.sh
# Predefines keyboards so that Keyboard Setup Assistant does not launch
#
# Fraser Hess
# © Pinnacol Assurance 2023
#
# Arguments:
#   NONE

# Uncomment line below for debugging
#set -x

declare -A keyboards

keyboards[50475-1133-0]=41 # Logitech MX Keys

for id type in "${(@kv)keyboards}"; do
  /usr/bin/defaults write /Library/Preferences/com.apple.keyboardtype.plist keyboardtype -dict-add "$id" -integer $type
done

# From https://github.com/pinnacol/macadmin/blob/609c8a21ac7558d896c59b5feaa75f11243ab4d1/scripts/DefineKeyboards/DefineKeyboards.sh
