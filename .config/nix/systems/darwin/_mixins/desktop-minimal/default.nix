{ pkgs, ... }:
{
  imports = [
    ./apps
    ./features
  ];

  environment.systemPackages = with pkgs; [
    darwin.lsusb
    ext4fuse
    neovide
    netbird-ui
  ];

  homebrew = {
    # taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "1password"
      "backblaze"
      "beeper"
      "font-chivo-mono"
      "font-iosevka"
      "font-iosevka-nerd-font"
      "font-monofett"
      "kicad"
      "macfuse"
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
