{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      google-fonts
      nerd-fonts.fira-code
      nerd-fonts.inconsolata
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.symbols-only
      inconsolata
      iosevka
      font-awesome
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      ubuntu-classic
    ];
  };
}
