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
      # camtasia2019
      # cricut-design-space
      fritzing
      gcc-arm-embedded-13
      gimp
      inkscape
      kitty
      lima
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
    taps = [ "netbirdio/tap" ];
    brews = [
      "conan"
    ];
    casks = [
      "ableton-live-standard"
      "arduino-ide"
      "autodesk-fusion"
      "balenaetcher"
      "backblaze"
      "creality-print"
      "focusrite-control"
      "freecad"
      "logi-options+"
      "microsoft-office"
      "mqtt-explorer"
      "mu-editor"
      "musicbrainz-picard"
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
      "Xcode" = 497799835;
      "Zeroconf Browser" = 1355001318;
    };
  };

  services = {
    tailscale.enable = true;
  };
}
