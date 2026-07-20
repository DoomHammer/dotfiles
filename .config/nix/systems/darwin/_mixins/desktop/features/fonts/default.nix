{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      source-code-pro
    ];
  };
}
