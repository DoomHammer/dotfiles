{
  config,
  hostname,
  inputs,
  lib,
  outputs,
  pkgs,
  platform,
  username,
  ...
}:
{
  # TODO: Remove when 25.11 released
  disabledModules = [ "system/applications.nix" ];
  imports = [
    inputs.nix-index-database.darwinModules.nix-index

    (inputs.nix-darwin-unstable + "/modules/system/applications.nix")

    # # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
    # # If one isn't already available: comment out the `nix-rosetta-builder` module below,
    # # uncomment the `linux-builder` module below, and run `darwin-rebuild switch`:
    # # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
    # # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
    #
    # inputs.nix-rosetta-builder.darwinModules.default

    inputs.virby.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew

    ./${hostname}

    ./_mixins/scripts
    ./_mixins/touchid
  ];

  # Only install the docs I use
  documentation = {
    enable = true;
    doc.enable = false;
    info.enable = false;
    man.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      git
      nvd
    ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = false;
    };

    caskArgs.no_quarantine = true;
  };
  nix-homebrew = {
    enable = true;
    user = username;

    taps = {
      "homebrew/core" = inputs.homebrew-core;
      "homebrew/cask" = inputs.homebrew-cask;
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
      inputs.doomhammer-nur.overlays.default
    ];
  };

  nix = {
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      trusted-users = [ "@admin" ];
      build-users-group = "nixbld";
      extra-platforms = [ "aarch64-linux" ];
    };
    extraOptions = ''
      trusted-users = root ${username}
    '';
    # linux-builder = {
    #   enable = true;
    #   #   ephemeral = true;
    #   #   maxJobs = 4;
    #   #   config = {
    #   #     virtualisation = {
    #   #       darwin-builder = {
    #   #         diskSize = 40 * 1024;
    #   #         memorySize = 8 * 1024;
    #   #       };
    #   #       cores = 6;
    #   #     };
    #   #   };
    # };
  };

  # nix-rosetta-builder = {
  #   enable = true;
  #
  #   cores = 6;
  #   memory = "24GiB";
  #   diskSize = "320GiB";
  #
  #   onDemand = true;
  # };

  services.virby = {
    enable = true;
    onDemand.enable = true;
    onDemand.ttl = 30; # Idle timeout in minutes
    rosetta = true;
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
    bash = {
      enable = true;
      # Enable bash completion for all interactive bash shells.
      #
      # NOTE. This doesn’t work with bash 3.2, which is the default on macOS.
      completion.enable = true;
    };
    zsh = {
      enable = true;
      enableBashCompletion = true;
      enableCompletion = false; # we are using home-manager zsh, so do not enable!
      enableFzfCompletion = true;
      enableFzfGit = true;
      enableSyntaxHighlighting = true;
    };
  };

  # Enable TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  # Also for tmux
  security.pam.enableSudoTouchId = true;

  system = {
    stateVersion = 5;
    # activationScripts run every time you boot the system or execute `darwin-rebuild`
    activationScripts = {
      diff = {
        supportsDryActivation = true;
        text = ''
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
        '';
      };
      postActivation.text = lib.mkBefore ''
        # Install Rosetta
        if ! pgrep -q oahd; then
          echo installing rosetta... >&2
          sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        fi

        # reload the settings and apply them without the need to logout/login
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        killall SystemUIServer
        sudo killall Finder
        #
        # # Make apps indexable
        # apps_source="${config.system.build.applications}/Applications"
        # moniker="Nix Trampolines"
        # app_target_base="$HOME/Applications"
        # app_target="$app_target_base/$moniker"
        # mkdir -p "$app_target"
        # ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
      '';
    };

    primaryUser = username;

    defaults = {
      LaunchServices.LSQuarantine = false;
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
        loginwindow.LoginwindowText = "Meraki";
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
          ReverseMouse = 1;
          ReverseTrackpad = 0;
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
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.mouse.tapBehavior" = 1; # Tap to click
        # Jump to the spot that's clicked on the scroll bar
        AppleScrollerPagingBehavior = true;
        AppleShowScrollBars = "Always";
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
        _FXShowPosixPathInTitle = false;
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
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };
    };
    startup.chime = false;
  };
}
