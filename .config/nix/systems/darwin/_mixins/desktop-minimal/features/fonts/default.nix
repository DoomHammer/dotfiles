{ pkgs, ... }:
{
  fonts = {
    packages =
      with pkgs;
      [
        font-awesome
        google-fonts
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.inconsolata
        nerd-fonts.iosevka
        nerd-fonts.iosevka-term
        nerd-fonts.roboto-mono
        nerd-fonts.symbols-only
        inconsolata
        iosevka
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji
        roboto
        roboto-mono
        ubuntu-classic
      ]
      ++ lib.optionals stdenv.isDarwin [
        sketchybar-app-font
        sf-symbols
      ];
  };
}
