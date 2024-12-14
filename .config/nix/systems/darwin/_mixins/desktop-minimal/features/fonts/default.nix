{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Inconsolata"
          "Iosevka"
          "IosevkaTerm"
          "NerdFontsSymbolsOnly"
        ];
      })
      inconsolata
      inconsolata-nerdfont
      iosevka
      font-awesome
      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      ubuntu_font_family
    ];
  };
}
