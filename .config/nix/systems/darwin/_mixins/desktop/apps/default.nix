{
  pkgs,
  ...
}:
{
  imports = [
    ./obs-studio
    ./utilities
    ./web-browsers
  ];

  environment = {
    systemPackages = with pkgs; [
      alacritty
      android-file-transfer
      # FIXME: Package ‘arduino-ide-2.3.6’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/ar/arduino-ide/package.nix:30 is not available on the requested hostPlatform:
      # arduino-ide
      audacity
      backblaze-downloader
      # TODO: Add Camtasia
      # Potential inspiration:
      # https://github.com/okpedersen/dotfiles/blob/fd9a42cdf1d9fa8a0e7ff6c30ec4309e19d90c43/spotify.nix#L32
      # https://github.com/Shopify/nixpkgs/blob/9777a72dd3ff6f774351c264723862a13c2480ea/pkgs/by-name/zo/zoom-us/package.nix#L59
      # https://github.com/noblepayne/lnd-boost-scraper/blob/4d91799daa9b3f4e5e2c1a0052603d427461d72f/module.nix#L38
      # https://github.com/thefloweringash/nixpkgs/blob/ece4c62d4b3f6f53935ece6b9cd5efe644cee79b/pkgs/development/python-modules/gurobipy/darwin.nix#L6
      # https://github.com/testfailed/nixos-config-srid/blob/df04659add20b7878e3c2a71e58c64399564bb26/overlays/shell-script/mosh.nix#L14
      # camtasia2019
      # cricut-design-space
      darwin.lsusb
      # FIXME: Package ‘freecad-1.0.1’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/by-name/fr/freecad/package.nix:232 is not available on the requested hostPlatform:
      # freecad
      fritzing
      gcc-arm-embedded-13
      gimp
      inkscape
      # FIXME: Package ‘kicad-9.0.2’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/applications/science/electronics/kicad/default.nix:313 is marked as broken, refusing to evaluate.
      # kicad
      kitty
      lima
      unstable.mas
      netbird-ui
      # FIXME: Package ‘nheko-0.12.0’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/nh/nheko/package.nix:92 is marked as broken, refusing to evaluate.
      # nheko
      openscad
      # FIXME: Package ‘orca-slicer-v2.3.0’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/or/orca-slicer/package.nix:217 is not available on the requested hostPlatform:
      # orca-slicer
      # FIXME: Package ‘qtwayland-5.15.16’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/development/libraries/qt-5/qtModule.nix:114 is not available on the requested hostPlatform:
      # picard
      plex-media-player
      pngpaste
      postman
      # FIXME: Package ‘webkitgtk-2.48.3+abi=4.1’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/development/libraries/webkitgtk/default.nix:254 is marked as broken, refusing to evaluate.
      # prusa-slicer
      # jetbrains.pycharm-community
      # FIXME: Package ‘qdirstat-1.9’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/qd/qdirstat/package.nix:56 is not available on the requested hostPlatform:
      # qdirstat
      rpiboot
      # FIXME: Package ‘rpi-imager-1.9.4’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/rp/rpi-imager/package.nix:89 is marked as broken, refusing to evaluate.
      # rpi-imager
      talosctl
      tpi
      signal
      syncthing-macos
      thonny
      # FIXME: Package ‘unetbootin-702’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/tools/cd-dvd/unetbootin/default.nix:85 is not available on the requested hostPlatform:
      # unetbootin
      wimlib
      # TODO: Add Konfig somehow

      # inputs.wegank-nur.packages.${system}.slipshow
    ];
  };

  homebrew = {
    brews = [
      "conan"
      "sdl2"
    ];
    casks = [
      # "autodesk-fusion"
      # "creality-print"
      "focusrite-control"
      "lastpass"
      "logi-options+"
      "microsoft-office"
      "mu-editor"
      "rustdesk"
      "thonny"
      "vial"
      "windows-app"
      # See also: https://github.com/nix-community/nix-vscode-extensions/blob/master/flake.nix

      # b0rk club
      "arduino-ide"
      "freecad"
      "jellyfin-media-player"
      "kicad"
      "nheko"
      "orcaslicer"
      "mqtt-explorer"
      "musicbrainz-picard"
      "qdirstat"
      "prusaslicer"
      "sequential"
      "scroll-reverser"
      "raspberry-pi-imager"
      "tailscale"
      "unetbootin"
    ];
    masApps = {
      "Backblaze" = 628638330;
      "Brother P-touch Editor" = 1453365242;
      "DaVinci Resolve" = 571213070;
      "Keynote" = 409183694;
      "Linn Kazoo" = 848937349;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Zeroconf Browser" = 1355001318;
    };
  };

  services = {
    # tailscale.enable = true;
    netbird.enable = true;
  };
}
