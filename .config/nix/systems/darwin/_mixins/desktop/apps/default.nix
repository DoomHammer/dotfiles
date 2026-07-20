{
  config,
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
    systemPackages =
      let

        my-lima = pkgs.unstable.lima.override {
          withAdditionalGuestAgents = true;
        };
      in
      with pkgs;
      [
        alacritty
        # FIXME: fuse unsupported
        # android-file-transfer
        # FIXME: Package ‘arduino-ide-2.3.6’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/ar/arduino-ide/package.nix:30 is not available on the requested hostPlatform:
        # arduino-ide
        audacity
        # backblaze-downloader
        # bitwarden-desktop
        camtasia2019
        unstable.cinny-desktop
        # FIXME: nix-prefetch-sth
        # cricut-design-space
        darwin.lsusb
        # FIXME: Package ‘freecad-1.0.1’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/by-name/fr/freecad/package.nix:232 is not available on the requested hostPlatform:
        # freecad
        fritzing
        gcc-arm-embedded-13
        # FIXME: not availabnle on darwin
        # gimp
        # Failing to launch
        inkscape
        # FIXME: Package ‘kicad-9.0.2’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/applications/science/electronics/kicad/default.nix:313 is marked as broken, refusing to evaluate.
        # kicad
        kitty
        libation
        libreoffice-bin
        libvirt
        linn-konfig
        my-lima
        unstable.mas
        nvfetcher
        netbird-ui
        # FIXME: Package ‘nheko-0.12.0’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/nh/nheko/package.nix:92 is marked as broken, refusing to evaluate.
        # nheko
        # FIXME
        omniwm
        openscad
        # FIXME: Package ‘orca-slicer-v2.3.0’ in /nix/store/i7ykaggappvy548qa4m5aw9msj5cz2vf-source/pkgs/by-name/or/orca-slicer/package.nix:217 is not available on the requested hostPlatform:
        # orca-slicer
        qemu
        # FIXME: Package ‘qtwayland-5.15.16’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/development/libraries/qt-5/qtModule.nix:114 is not available on the requested hostPlatform:
        # picard
        # FIXME: container-init problems
        # plex-desktop
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
        unstable.tenacity
        tpi
        # FIXME:: Package ‘signal-desktop-7.70.0’ in /nix/store/805qxiz47zwd8hm35hbpk3ifr8slpj2r-source/pkgs/by-name/si/signal-desktop/package.nix:250 is not available on the requested hostPlatform:
        # signal-desktop
        syncthing-macos
        thonny
        # FIXME: Package ‘unetbootin-702’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/tools/cd-dvd/unetbootin/default.nix:85 is not available on the requested hostPlatform:
        # unetbootin
        virt-viewer
        virt-manager
        wimlib
      ];
  };

  homebrew = {

    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "cmake"
      "conan@1"
      "conan"
      "qt@5"
      "qt@6"
      "sdl2"
    ];
    casks = [
      # "autodesk-fusion"
      "bitwarden"
      # "creality-print"
      "focusrite-control"
      "lastpass"
      "logi-options+"
      # "microsoft-office"
      "mu-editor"
      "rustdesk"
      "thonny"
      "vial"
      "windows-app"
      # See also: https://github.com/nix-community/nix-vscode-extensions/blob/master/flake.nix

      # b0rk club
      "arduino-ide"
      "freecad"
      "inkscape"
      "jellyfin-media-player"
      "kicad"
      "nheko"
      "orcaslicer"
      "mqtt-explorer"
      "musicbrainz-picard"
      "qdirstat"
      "prusaslicer"
      "raspberry-pi-imager"
      "sequential"
      "scroll-reverser"
      "signal"
      "tailscale-app"
      "unetbootin"
      "ungoogled-chromium"
      # "BarutSRB/tap/omniwm"
    ];
    masApps = {
      # FIXME: No app found with ID. WTF?
      # "Backblaze" = 628638330;
      "Brother P-touch Editor" = 1453365242;
      "DaVinci Resolve" = 571213070;
      "Keynote" = 409183694;
      "Linn Kazoo" = 848937349;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "WireGuard" = 1451685025;
      "Zeroconf Browser" = 1355001318;
    };
  };

  services = {
    # tailscale.enable = true;
    netbird.enable = true;
  };
}
