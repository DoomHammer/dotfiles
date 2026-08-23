{ ... }:
{
  imports = [
    ../_mixins/desktop-minimal
    ../_mixins/desktop
  ];

  services = {
    awl = {
      enable = true;
    };
  };
}
