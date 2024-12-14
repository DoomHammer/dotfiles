{ pkgs, ... }:
{
  imports = [
    ./apps
    ./features
  ];

  environment.systemPackages = with pkgs; [ ];

  homebrew = {
    # taps = builtins.attrNames config.nix-homebrew.taps;
    taps = [ "netbirdio/tap" ];
    casks = [
      "backblaze"
      "beeper"
      "font-chivo-mono"
      "font-iosevka"
      "font-iosevka-nerd-font"
      "font-monofett"
      "netbird-ui"
      "notion-calendar"
      "obsidian"
      # Possible alternative: https://github.com/ther0n/UnnaturalScrollWheels
      "scroll-reverser"
      "signal"
      "tailscale"
      "the-unarchiver"
      # See also: https://github.com/nix-community/nix-vscode-extensions/blob/master/flake.nix
      "visual-studio-code"
      "vlc"
      "wezterm"
    ];
  };
}
