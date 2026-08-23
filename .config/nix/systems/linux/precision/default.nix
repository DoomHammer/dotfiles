{
  pkgs,
  inputs,
  platform,
  ...
}:
{
  # Ubuntu 24.04

  environment.systemPackages = with pkgs; [
    lima
  ];

  services.awl = {
    enable = true;
    package = inputs.doomhammer-nur.packages.${platform}.awl;
  };

  # AppArmor profile for bubblewrap
  environment.etc."apparmor.d/nix-bwrap".text = ''
    abi <abi/4.0>,
    include <tunables/global>

    profile bwrap ${pkgs.bubblewrap}/bin/bwrap flags=(unconfined) {
      userns,
      include if exists <local/bwrap>
    }
  '';
}
