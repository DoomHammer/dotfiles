{pkgs, ... }: {
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";
  # nixpkgs.config.allowUnfree = true;

  users.users.doomhammer = {
    name = "doomhammer";
    home = "/Users/doomhammer";
  };

  programs.bash.enable = true;
  # Enable bash completion for all interactive bash shells.
  #
  # NOTE. This doesn’t work with bash 3.2, which is the default on macOS.
  # programs.bash.enableCompletion;
  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableFzfCompletion = true;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableSyntaxHighlighting = true;
  programs.zsh.shellInit = ''
    skip_global_compinit=1
  '';
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  environment.systemPackages = [
    pkgs.alacritty
    pkgs.alt-tab-macos
    pkgs.android-file-transfer
    pkgs.audacity
    pkgs.fritzing
    pkgs.gcc-arm-embedded-13
    pkgs.gimp
    pkgs.grandperspective
    pkgs.inkscape
    pkgs.kitty
    pkgs.openscad
    pkgs.prusa-slicer
    pkgs.jetbrains.pycharm-community
    pkgs.utm
  ];

  fonts.packages = [
    pkgs.inconsolata
    pkgs.inconsolata-nerdfont
    pkgs.iosevka
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/core"
      "netbirdio/tap"
    ];
    brews = [ "conan" ];
    casks = [
      "ableton-live-standard"
      "arduino-ide"
      "autodesk-fusion"
      "backblaze"
      "backblaze-downloader"
      "balenaetcher"
      "beeper"
      # TODO: Add Camtasia
      "creality-slicer"
      # TODO: Add Cricut
      # TODO: Add DaVinci Resolve
      "firefox"
      "focusrite-control"
      "font-chivo-mono"
      "font-iosevka"
      "font-iosevka-nerd-font"
      "font-monofett"
      "google-chrome"
      "logi-options-plus"
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

  security.pam.enableSudoTouchIdAuth = true;
  system.defaults.NSGlobalDomain."com.apple.sound.beep.feedback" = 0;
  system.defaults.CustomUserPreferences = {
    com.apple.systemsound = {
      "com.apple.sound.uiaudio.enabled" = 0;
    };
    # Disable MissionControl bindings for CTRL+Arrow as they're better in Terminal
    com.apple.symbolichotkeys = {
      AppleSymbolicHotKeys = {
        "79" = {enabled = 0; value = { parameters = [65535 123 8650752]; type = "standard";};};
        "80" = {enabled = 0; value = { parameters = [65535 123 8781824]; type = "standard";};};
        "81" = {enabled = 0; value = { parameters = [65535 124 8650752]; type = "standard";};};
        "82" = {enabled = 0; value = { parameters = [65535 124 8781824]; type = "standard";};};
      };
    };
    com.pilotmoon.scroll-reverser = {
      InvertScrollingOn = 1;
      ReverseMouse = 0;
      ReverseX = 1;
      StartAtLogin = 1;
    };
  };
  system.defaults.dock = {
    autohide = true;
    persistent-apps = [];
    persistent-others = [];
  };
  system.defaults.finder.CreateDesktop = false;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.trackpad.Clicking = true;
  system.startup.chime = false;
  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
