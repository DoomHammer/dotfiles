{ pkgs, ... }: {
  # Ubuntu 24.04

  environment.systemPackages = with pkgs; [
    lima
  ];

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
