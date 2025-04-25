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
  ];

  environment = {
    systemPackages = with pkgs; [
      comma
      git
      nvd
    ];
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
      trusted-users = root $USER
    '';
    linux-builder = {
      enable = true;
      # ephemeral = true;
      # maxJobs = 4;
      # config = {
      #   virtualisation = {
      #     darwin-builder = {
      #       diskSize = 40 * 1024;
      #       memorySize = 8 * 1024;
      #     };
      #     cores = 6;
      #   };
      # };
    };
  };

  networking.hostName = hostname;
  networking.computerName = hostname;

  programs = {
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
  security.pam.enableSudoTouchIdAuth = true;

  services = {
    nix-daemon.enable = true;
  };

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
      '';
      postUserActivation.text = ''
        # reload the settings and apply them without the need to logout/login
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        killall SystemUIServer
        sudo killall Finder

        # Make apps indexable
        apps_source="${config.system.build.applications}/Applications"
        moniker="Nix Trampolines"
        app_target_base="$HOME/Applications"
        app_target="$app_target_base/$moniker"
        mkdir -p "$app_target"
        ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
      '';
    };
  };
}
