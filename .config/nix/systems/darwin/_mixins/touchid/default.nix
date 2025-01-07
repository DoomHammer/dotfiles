{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.security.pam;
in
{
  options = {
    security.pam.enableSudoTouchId = mkEnableOption ''
      Enable sudo authentication with Touch ID

    '';
  };

  config = lib.mkIf (cfg.enableSudoTouchId) {
    environment.etc."pam.d/sudo_local" = {
      text = ''
        auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
        auth       sufficient     pam_tid.so
      '';
    };
  };
}
