{
  config,
  hostname,
  inputs,
  lib,
  outputs,
  pkgs,
  platform,
  ...
}:
{
  imports = [
    inputs.nix-index-database.darwinModules.nix-index
    ./${hostname}
    ./_mixins/desktop
    ./_mixins/scripts
  ];

  # Only install the docs I use
  documentation.enable = true;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = true;

  environment = {
    systemPackages = with pkgs; [
      git
      mas
      nvd
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
    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
      "netbirdio/tap"
    ];
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

  nixpkgs = {
    # Configure your nixpkgs instance
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${platform}";
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # Add overlays exported from other flakes:
    ];
  };

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  networking.hostName = hostname;
  networking.computerName = hostname;

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    info.enable = false;
    nix-index-database.comma.enable = true;
    bash.enable = true;
    # Enable bash completion for all interactive bash shells.
    #
    # NOTE. This doesn’t work with bash 3.2, which is the default on macOS.
    bash.enableCompletion = true;
    zsh.enable = true;
    zsh.enableBashCompletion = true;
    zsh.enableCompletion = false; # we are using home-manager zsh, so do not enable!
    zsh.enableFzfCompletion = true;
    zsh.enableFzfGit = true;
    zsh.enableSyntaxHighlighting = true;
  };

  # Enable TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  services = {
    activate-system.enable = true;
    nix-daemon.enable = true;
    tailscale.enable = true;
  };

  system = {
    # activationScripts run every time you boot the system or execute `darwin-rebuild`
    activationScripts = {
      diff = {
        supportsDryActivation = true;
        text = ''
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
        '';
      };
      # reload the settings and apply them without the need to logout/login
      postUserActivation.text = ''
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };
    checks = {
      verifyNixChannels = false;
    };
    defaults = {
      CustomUserPreferences = {
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        "com.apple.controlcenter" = {
          BatteryShowPercentage = true;
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.finder" = {
          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf"; # Search current folder by default
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
        };
        # Prevent Photos from opening automatically
        "com.apple.ImageCapture".disableHotPlug = true;
        "com.apple.screencapture" = {
          location = "~/Documents/Screenshots";
          type = "png";
        };
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          # Check for software updates daily, not just once per week
          ScheduleFrequency = 1;
          # Download newly available updates in background
          AutomaticDownload = 0;
          # Install System data files & security updates
          CriticalUpdateInstall = 1;
        };
        # Disable MissionControl bindings for CTRL+Arrow as they're better in Terminal
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            "79" = {
              enabled = 0;
              value = {
                parameters = [
                  65535
                  123
                  8650752
                ];
                type = "standard";
              };
            };
            "80" = {
              enabled = 0;
              value = {
                parameters = [
                  65535
                  123
                  8781824
                ];
                type = "standard";
              };
            };
            "81" = {
              enabled = 0;
              value = {
                parameters = [
                  65535
                  124
                  8650752
                ];
                type = "standard";
              };
            };
            "82" = {
              enabled = 0;
              value = {
                parameters = [
                  65535
                  124
                  8781824
                ];
                type = "standard";
              };
            };
          };
        };
        "com.apple.systemsound" = {
          "com.apple.sound.uiaudio.enabled" = 0;
        };
        "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
        # Turn on app auto-update
        "com.apple.commerce".AutoUpdate = true;
        "com.pilotmoon.scroll-reverser" = {
          InvertScrollingOn = 1;
          ReverseMouse = 0;
          ReverseX = 1;
          StartAtLogin = 1;
        };
      };
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = null;
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        "com.apple.sound.beep.feedback" = 0;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;
      };
      dock = {
        orientation = "bottom";
        autohide = true;
        persistent-apps = [ ];
        persistent-others = [ ];
        show-recents = false;
        tilesize = 48;
        # Disable hot corners
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      menuExtraClock = {
        ShowAMPM = false;
        ShowDate = 1; # Always
        Show24Hour = true;
        ShowSeconds = false;
      };
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 300;
      };
      smb.NetBIOSName = hostname;
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };
    };
    startup.chime = false;
  };
}
