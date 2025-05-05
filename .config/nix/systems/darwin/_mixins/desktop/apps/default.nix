{ pkgs, ... }:
{
  imports = [
    ./obs-studio
    ./utilities
    ./web-browsers
  ];

  environment = {
    systemPackages = with pkgs; [
      mas
      alacritty
      android-file-transfer
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
      fritzing
      gcc-arm-embedded-13
      gimp
      inkscape
      jellyfin-media-player
      kitty
      lima
      # netbird-ui
      openscad
      pngpaste
      rpiboot
      talosctl
      tpi
      jetbrains.pycharm-community
      signal
      # TODO: Add Konfig somehow
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;

    # taps = builtins.attrNames config.nix-homebrew.taps;
    taps = [
      "netbirdio/tap"
    ];
    brews = [
      "conan"
      "sdl2"
    ];
    casks = [
      "ableton-live-standard"
      "arduino-ide"
      "autodesk-fusion"
      "balenaetcher"
      "backblaze"
      "beeper"
      "creality-print"
      "focusrite-control"
      "freecad"
      "logi-options+"
      "microsoft-office"
      "mqtt-explorer"
      "mu-editor"
      "musicbrainz-picard"
      "netbird-ui"
      "nheko"
      "obs"
      "orcaslicer"
      "plex"
      "prusaslicer"
      "qdirstat"
      "raspberry-pi-imager"
      "sequential"
      # Possible alternative: https://github.com/ther0n/UnnaturalScrollWheels
      "syncthing"
      "thonny"
      "unetbootin"
      "windows-app"
      # See also: https://github.com/nix-community/nix-vscode-extensions/blob/master/flake.nix
    ];
    masApps = {
      "Brother P-touch Editor" = 1453365242;
      "DaVinci Resolve" = 571213070;
      "Keynote" = 409183694;
      # "Linn" = 1292218680; # Sadly, this does not work
      "Linn Kazoo" = 848937349;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      # "Xcode" = 497799835;
      "Zeroconf Browser" = 1355001318;
    };
  };

  services = {
    tailscale.enable = true;
  };
}
