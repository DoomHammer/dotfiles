{ pkgs, ... }:
{
  imports = [
    ./apps
    ./features
  ];

  environment.systemPackages = with pkgs; [
    # Broken on darwin?
    # contour
    darwin.lsusb
    ext4fuse
    neovide
    netbird-ui
    obsidian
    rio
    the-unarchiver
    unnaturalscrollwheels
    # FIXME: Package ‘vlc-3.0.21’ in /nix/store/j95fcik6rzsydwips4m89dmlvfj9hg9y-source/pkgs/by-name/vl/vlc/package.nix:326 is not available on the requested hostPlatform:
    # vlc
    wezterm
  ];

  homebrew = {
    # taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "backblaze"
      "beeper"
      "macfuse"
      "notion-calendar"
      "tailscale-app"
      # See also: https://github.com/nix-community/nix-vscode-extensions/blob/master/flake.nix
      "visual-studio-code"
      "vlc"
    ];
  };
}
