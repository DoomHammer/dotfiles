# Inspired by: https://github.com/d-issy/dotfiles/blob/1328b6bd75cbf1b0ff915917cf434e42e03f2c4f/modules/dot/programs/navi.nix
{
  config,
  lib,
  ...
}:

let
  cfg = config.navi-cheats;

  mkDescriptionText = description: lib.optionalString (description != "") " ${description}";

  mkAliasText = alias: lib.optionalString (alias != null) " :: ${alias}";

  mkEntry =
    entry: "#${mkDescriptionText entry.description}${mkAliasText entry.alias}\n${entry.command}";

  mkVariable = name: command: "$ ${name}: ${command}";

  managedCheatsDir = "navi/cheats";
  managedCheatsPath = "${config.xdg.dataHome}/${managedCheatsDir}";

  mkSection =
    cheatName: section:
    let
      tags = if section.tags == [ ] then [ cheatName ] else section.tags;
      entries = lib.concatStringsSep "\n\n" (map mkEntry section.entries);
      variables = lib.concatStringsSep "\n" (lib.mapAttrsToList mkVariable section.variables);
      body = lib.concatStringsSep "\n\n" (
        lib.filter (value: value != "") [
          variables
          entries
        ]
      );
    in
    "% ${lib.concatStringsSep ", " tags}\n\n${body}";

  mkCheatText =
    cheatName: cheat: "${lib.concatStringsSep "\n\n" (map (mkSection cheatName) cheat.sections)}\n";

  mkCheatFile =
    cheatName: cheat:
    lib.nameValuePair "${managedCheatsDir}/${cheatName}.cheat" {
      text = mkCheatText cheatName cheat;
    };
in
{
  options.navi-cheats = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.sections = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                tags = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = "Section tags. Defaults to the cheat name when empty.";
                };

                entries = lib.mkOption {
                  type = lib.types.listOf (
                    lib.types.submodule {
                      options = {
                        description = lib.mkOption {
                          type = lib.types.str;
                          description = "Entry description.";
                        };

                        alias = lib.mkOption {
                          type = lib.types.nullOr lib.types.str;
                          default = null;
                          description = "Entry alias shown after :: in the description.";
                        };

                        command = lib.mkOption {
                          type = lib.types.lines;
                          description = "Entry command.";
                        };
                      };
                    }
                  );
                  default = [ ];
                  description = "Cheat entries.";
                };

                variables = lib.mkOption {
                  type = lib.types.attrsOf lib.types.lines;
                  default = { };
                  description = "Navi variables for this section.";
                };
              };
            }
          );
          default = [ ];
          description = "Cheat sections.";
        };
      }
    );
    default = { };
    description = "Navi cheats to generate under the dotfiles-managed navi cheats path.";
    example.git.sections = [
      {
        tags = [ "git" ];
        entries = [
          {
            description = "Git Status";
            alias = "gs";
            command = "git status";
          }
        ];
      }
    ];
  };

  config = {
    programs.navi.settings.cheats.paths = [
      managedCheatsPath
    ];

    xdg.dataFile = builtins.listToAttrs (lib.mapAttrsToList mkCheatFile cfg);
  };
}
