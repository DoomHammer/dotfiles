{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.inconsolata
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.symbols-only
      inconsolata
      iosevka
      font-awesome
      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      ubuntu_font_family
    ];
  };
}
