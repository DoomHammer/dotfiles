{ pkgs, ... }:
{
  imports = [
    ./apps
    ./features
  ];

  environment.systemPackages = with pkgs; [
    ext4fuse
    neovide
  ];

  homebrew = {
    # taps = builtins.attrNames config.nix-homebrew.taps;
    taps = [ "netbirdio/tap" ];
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
