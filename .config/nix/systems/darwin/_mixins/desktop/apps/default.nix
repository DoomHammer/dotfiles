_: {
  imports = [
    ./obs-studio
    ./utilities
  ];

  environment = {
    systemPackages = with pkgs; [
      mas
      alacritty
      android-file-transfer
      audacity
      fritzing
      gcc-arm-embedded-13
      gimp
      grandperspective
      inkscape
      kitty
      openscad
      pngpaste
      prusa-slicer
      jetbrains.pycharm-community
      utm
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;

    # taps = builtins.attrNames config.nix-homebrew.taps;
    taps = [ "netbirdio/tap" ];
    brews = [
      "conan"
      "conan@1"
    ];
    casks = [
      "ableton-live-standard"
      "arduino-ide"
      "autodesk-fusion"
      "backblaze"
      "backblaze-downloader"
      "balenaetcher"
      "beeper"
      # TODO: Add Camtasia
      "creality-print"
      # TODO: Add Cricut
      # TODO: Add DaVinci Resolve
      "firefox"
      "focusrite-control"
      "font-chivo-mono"
      "font-iosevka"
      "font-iosevka-nerd-font"
      "font-monofett"
      "google-chrome"
      # "logi-options-plus"
      "logitech-unifying"
      "kicad"
      "microsoft-office"
      "mqtt-explorer"
      "mu-editor"
      "musicbrainz-picard"
      "netbird-ui"
      "notion-calendar"
      "obs"
      "obsidian"
      "plex"
      "raspberry-pi-imager"
      "sequential"
      # Possible alternative: https://github.com/ther0n/UnnaturalScrollWheels
      "scroll-reverser"
      "signal"
      "syncthing"
      "squirreldisk"
      "tailscale"
      "the-unarchiver"
      "thonny"
      "unetbootin"
      # See also: https://github.com/nix-community/nix-vscode-extensions/blob/master/flake.nix
      "visual-studio-code"
      "vlc"
      "wezterm"
    ];
    masApps = {
      "Brother P-touch Editor" = 1453365242;
      "Keynote" = 409183694;
      "Linn Kazoo" = 848937349;
      # TODO: Add Konfig somoehow
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
