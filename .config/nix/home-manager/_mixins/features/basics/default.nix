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
  dir = "${flakePath config}/home-manager/_mixins/features/basics";
in
{
  home.packages = with pkgs; [
    p7zip
    btop
    curl
    doggo
    dust
    eza
    fd
    htop
    jq
    just
    lesspipe
    nodejs # yuck
    ripgrep
    silver-searcher
    tre # spellchecker:disable-line
    unzip
    wget
    wtfutil
    zstd
  ];
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "solarized_light";
        # color_theme = TTY
        # Theme background = true
        # force_TTY = true
      };
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = "auto";
    };
    fd.enable = true;
    htop = {
      enable = true;
      settings = {
        hide_kernel_threads = 1;
        hide_userland_threads = 0;
        hide_running_in_container = 0;
        shadow_other_users = 0;
        show_thread_names = 0;
        show_program_path = 1;
        highlight_base_name = 0;
        highlight_deleted_exe = 1;
        shadow_distribution_path_prefix = 0;
        highlight_megabytes = 1;
        highlight_threads = 1;
        highlight_changes = 0;
        highlight_changes_delay_secs = 5;
        find_comm_in_cmdline = 1;
        strip_exe_from_cmdline = 1;
        show_merged_command = 0;
        header_margin = 1;
        screen_tabs = 1;
        detailed_cpu_time = 0;
        cpu_count_from_one = 0;
        show_cpu_smt_labels = 0;
        show_cpu_usage = 1;
        show_cpu_frequency = 0;
        show_cached_memory = 1;
        update_process_names = 0;
        account_guest_in_cpu_meter = 0;
        color_scheme = 0;
        enable_mouse = 1;
      };
    };
    lesspipe.enable = true;
    man.enable = true;
    ripgrep = {
      enable = true;
      arguments = [
        # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
        "--max-columns=150"
        "--max-columns-preview"

        # Search hidden files / directories (e.g. dotfiles) by default
        "--hidden"

        # Using glob patterns to include/exclude files or folders
        "--glob=!.git/*"

        # Set the colors.
        "--colors=line:none"
        "--colors=line:style:bold"

        # Because who cares about case!?
        "--smart-case"
      ];
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
  xdg.configFile."btop/themes/solarized_light.theme".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/btop-config/btop/themes/solarized_light.theme";
}
