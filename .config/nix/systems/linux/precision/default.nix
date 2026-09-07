{
  pkgs,
  inputs,
  platform,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    system = platform;
    config.allowUnfree = true;
  };
in
{
  # Ubuntu 24.04
  imports = [
    "${inputs.nixpkgs}/nixos/modules/services/networking/eternal-terminal.nix"
  ];
  config = {

    environment.systemPackages = with pkgs; [
      eternal-terminal
      unstable.lima
    ];

    services = {
      awl = {
        enable = true;
        package = inputs.doomhammer-nur.packages.${platform}.awl;
      };
      eternal-terminal = {
        enable = true;
      };
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
  };
}
