{
  config,
  flakePath,
  pkgs,
  ...
}:

let
  # Out-of-store symlinks require absolute paths when using a flake config. This
  # is because relative paths are expanded after the flake source is copied to
  # a store path which would get us read-only store paths.
  dir = "${flakePath config}/home-manager/_mixins/features/neovim";
in
{
  home.packages = with pkgs; [ pkgs.unstable.neovide ];

  programs.neovim = {
    package = pkgs.unstable.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = with pkgs; [
      fd
      ripgrep # used by obsidian.nvim, and other plugins

      git
      lazygit

      # needed to compile fzf-native for telescope-fzf-native.nvim
      clang
      gcc
      gnumake

      # needed to compile some Language Servers
      nodejs
      python310

      # Lua support
      stylua

      # language servers
      deno
      lua-language-server
      nil # Nix LSP
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      shellcheck # called by bash-language-server

      # Rust support
      lldb # debug adapter

      # Nix support
      nixfmt-rfc-style
      nixpkgs-fmt
      statix
      deadnix
    ];
  };

  xdg.configFile = {
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/init.lua";
    "nvim/lazyvim.json".source = config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lazyvim.json";
    "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lazy-lock.json";
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${dir}/neovim-config/nvim/lua";
  };
}
