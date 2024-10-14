{
  perSystem =
    {
      pkgs,
      self',
      config,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          name = "dotfiles";
          meta.description = "Development shell for this configuration";

          shellHook = config.pre-commit.installationScript;

          DIRENV_LOG_FORMAT = "";

          packages = [
            pkgs.git # flakes require git
            self'.formatter # nix formatter
            pkgs.nix-output-monitor # get clean diff between generations
          ];

          inputsFrom = [ config.treefmt.build.devShell ];
        };

        nixpkgs = pkgs.mkShellNoCC {
          packages = builtins.attrValues {
            inherit (pkgs)
              # package creation helpers
              nurl
              nix-init

              # nixpkgs dev stuff
              hydra-check
              nixpkgs-lint
              nixpkgs-review
              nixpkgs-hammering

              # nix helpers
              nix-melt
              nix-tree
              nix-inspect
              nix-search-cli
              ;
          };
        };
      };
    };
}
