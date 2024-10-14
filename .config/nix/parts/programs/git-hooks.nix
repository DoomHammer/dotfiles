{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { lib, config, ... }:
    let
      # don't format these
      excludes = [
        "flake.lock"
        "r'.+\.age$'"
        "r'.+\.patch$'"
        ".gitignore.global"
        "lazy-lock.json"
      ];

      mkHook =
        prev:
        lib.attrsets.recursiveUpdate {
          inherit excludes;
          enable = true;
          fail_fast = true;
          verbose = true;
        } prev;
    in
    {
      pre-commit = {
        check.enable = true;

        settings = {
          inherit excludes;

          hooks = {
            # make sure our nix code is of good quality before we commit
            statix = mkHook { };
            deadnix = mkHook { };
            # flake-checker = mkHook { };

            actionlint = mkHook { files = "^.github/workflows/"; };

            shellcheck = mkHook { };

            # ensure we have nice formatting
            nixfmt-rfc-style = mkHook { };
            treefmt = mkHook { package = config.treefmt.build.wrapper; };
            # luacheck = mkHook { };
            stylua = mkHook { };
            editorconfig-checker = mkHook {
              enable = lib.modules.mkForce false;
              always_run = true;
            };

            # check for dead links
            # lychee = mkHook { excludes = [ "^(?!.*\.md$).*" ]; };

            check-yaml = mkHook { };

            # make sure there are no typos in the code
            typos = mkHook {
              settings = {
                write = true;
              };
            };
          };
        };
      };
    };
}
