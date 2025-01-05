# Potential inspiration:
# - https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/tmux-plugins/default.nix
{ pkgs, ... }:
let
  plugins = pkgs.tmuxPlugins // pkgs.callPackage ./custom-plugins.nix { };
in
{
  home.packages = with pkgs; [
    tmux
    zsh
  ];
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tmux.enable
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
      ## Use xterm keys (makes eg. Ctrl+Arrow navigate words)
      set-window-option -g xterm-keys on

      # tell Tmux that outside terminal supports true color
      set -ag terminal-overrides ",alacritty:RGB"
      # Enable RGB colour if running in xterm
      set-option -sa terminal-overrides ",xterm*:Tc"

      ## Windows style
      set-option -g status-style fg=yellow,bg=default
      set-window-option -g pane-active-border-style ""

      ## A bit more space in right status bar
      set -g status-right-length 50

      ## Rename windows to fit current application
      setw -g automatic-rename on

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # PageUp/PageDown works for scrolling
      bind-key -T root PPage if-shell -F "#{alternate_on}" "send-keys PPage" "copy-mode -e; send-keys PPage"
      bind-key -T copy-mode-vi PPage send-keys -X page-up
      bind-key -T copy-mode-vi NPage send-keys -X page-down

      # Same for the mouse scroll button
      bind-key -T root WheelUpPane if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; copy-mode -e; send-keys -M"
      bind-key -T root WheelDownPane if-shell -F -t = "#{alternate_on}" "send-keys -M" "select-pane -t =; send-keys -M"
      bind-key -T copy-mode-vi WheelUpPane send-keys -X halfpage-up
      bind-key -T copy-mode-vi WheelDownPane send-keys -X halfpage-down

      # Enable image preview in yazi ( https://yazi-rs.github.io/docs/image-preview )
      set -g allow-passthrough on

      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      # Don't detach tmux when exiting session
      set -g detach-on-destroy off

      # Set titles after running commands
      set-option -g set-titles on
      set-option -g set-titles-string '#W'

      # Toggle prefix on/off with F12 (for nested remote sessions)
      bind -T root F12  \
        set prefix None \;\
        set key-table off \;\
        if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
        refresh-client -S \;\

      bind -T off F12 \
        set -u prefix \;\
        set -u key-table \;\
        refresh-client -S

      # Navi integration
      bind-key -T prefix C-g split-window \
        "$SHELL --login -i -c 'navi --print | head -n 1 | tmux load-buffer -b tmp - ; tmux paste-buffer -p -t {last} -b tmp -d'"
    '';
    mouse = true;
    newSession = true;
    plugins = [
      {
        plugin = plugins.sensible;
        extraConfig = "bind R source-file '~/.config/tmux/tmux.conf'";
      }
      {
        plugin = plugins.resurrect;
        extraConfig = "set -g @resurrect-capture-pane-contents 'on'";
      }
      {
        plugin = plugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
        '';
      }
      {
        plugin = plugins.pain-control;
        extraConfig = "";
      }
      {
        plugin = plugins.yank;
        extraConfig = "set -g @yank_selection 'primary'";
      }
      {
        plugin = plugins.sessionist;
        extraConfig = "";
      }
      # <Prefix>+u to select URL
      {
        plugin = plugins.fzf-tmux-url;
        extraConfig = "";
      }
      {
        plugin = plugins.man;
        extraConfig = ''
          set -g @man-size '40%'
          set -g @man-orientation 'h'
          set -g @man-shell-interactive 'off'
        '';
      }
      {
        plugin = plugins.newline-detector;
        extraConfig = "";
      }
      {
        plugin = plugins.floax;
        extraConfig = ''
          # M- means "hold Meta/Alt"
          set -g @floax-bind '-n M-p'

          # The default width and height of the floating pane
          set -g @floax-width '90%'
          set -g @floax-height '90%'
        '';
      }
      {
        plugin = plugins.which-key;
        extraConfig = ''
          set -g @tmux-which-key-xdg-enable 1;
          set -g @tmux-which-key-disable-autobuild 1
        '';
      }
      # TODO: take a look at https://github.com/fcsonline/tmux-thumbs
      # TODO: take a look at https://github.com/rafi/tmux-pass
      # TODO: take a look at https://github.com/roosta/tmux-fuzzback
    ];
    prefix = "C-a";
    sensibleOnTop = true;
    # shortcut = "a";
    # terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
