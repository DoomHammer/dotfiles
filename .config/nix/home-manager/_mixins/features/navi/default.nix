{
  pkgs,
  config,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    navi
    skim
  ];

  home.activation = {
    updateNaviCheats = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PATH="${
        lib.makeBinPath (
          with pkgs;
          [
            gawk
            ghq
            git
          ]
        )
      }:$PATH"
      echo "Updating Navi cheats"
      PATHLIST=$(grep ' -' ~/.config/navi/config.yaml | awk '{print $2}')

      for path in $PATHLIST; do
        path=$(eval echo "$path")
        if [ ! -d "$path" ]; then
          repo=$(echo "$path" | sed -e 's/.*github.com\//git@github.com:/')
          ghq get "''${repo}.git"
        fi
      done
    '';
  };

  # FIXME: This should be modified for Linux hosts
  xdg.configFile."navi/config.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Application Support/navi/config.yaml";

  programs.navi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      finder = {
        command = "skim";
      };
      cheats = {
        paths = [
          "$HOME/src/github.com/denisidoro/cheats"
          "$HOME/src/github.com/denisidoro/navi-tldr-pages"
          "$HOME/src/github.com/papanito/cheats"
          "$HOME/src/github.com/tsologub/navi-cheats"
          "$HOME/src/github.com/kbknapp/navi-cheats"
          "$HOME/src/github.com/doomhammer/personal-navi-cheats"
          # "$HOME/src/github.com/denisidoro/dotfiles"
          # "$HOME/src/github.com/mrVanDalo/navi-cheats"
          # "$HOME/src/github.com/chazeon/my-navi-cheats"
          # "$HOME/src/github.com/caojianhua/MyCheat"
          # "$HOME/src/github.com/Kidman1670/cheats"
          # "$HOME/src/github.com/isene/cheats"
          # "$HOME/src/github.com/m42martin/navi-cheats"
          # "$HOME/src/github.com/infosecstreams/cheat.sheets"
          # "$HOME/src/github.com/prx2090/cheatsheets-for-navi"
          # "$HOME/src/github.com/esp0xdeadbeef/cheat.sheets"
          # "$HOME/src/github.com/badele/cheats"
        ];
      };
    };
  };
}
