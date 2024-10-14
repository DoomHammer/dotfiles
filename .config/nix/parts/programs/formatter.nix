{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, config, ... }:
    {
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        projectRootFile = "flake.nix";

        programs = {
          shellcheck.enable = true;
          taplo.enable = true;
          # yamlfmt.enable = true;

          nixfmt = {
            enable = true;
          };

          prettier = {
            enable = true;
            package = pkgs.prettierd;
            excludes = [ "*.age" ];
            settings = {
              editorconfig = true;
            };
          };

          stylua = {
            enable = true;
          };

          shfmt = {
            enable = true;
            indent_size = 2;
          };
        };
      };
    };
}
