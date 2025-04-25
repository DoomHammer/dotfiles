{
  flake = rec {
    # Usage: nix flake new -t github:doomhammer/dotfiles .
    # Usage: nix flake new -t 'github:doomhammer/dotfiles#terraform-gcp' .
    templates = {
      simple = {
        path = ./simple;
        description = "";
      };
      default = templates.simple;
    };
  };

}
