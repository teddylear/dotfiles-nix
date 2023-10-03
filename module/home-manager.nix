{ pkgs, ... }:

{
  # add home-manager user settings here
  home.packages = with pkgs; [
      # cli tools
      git
      ripgrep
      bat
      jq
      tree
      delta
      sd
      neofetch
      mcfly
      zsh
      fd
      gh
      awscli2
      unzip
      # NOTE: Add eza when it's available
      # eza

      # Lua and Neovim build stuff
      luajitPackages.luarocks-nix
      cmake
      gettext
      ninja
  ];
  home.stateVersion = "23.05";

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
        # better prefix key
        unbind C-b
        set-option -g prefix C-w
        bind-key C-w send-prefix

        # use <prefix> s for horizontal split at current directory
        bind s split-window -v -c "#{pane_current_path}"
        # use <prefix> v for vertical split at current directory
        bind v split-window -h -c "#{pane_current_path}"
        bind '"' new-window -c $TMUX_WIN_PATH

        bind t choose-tree

        # Vim like pane movement
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # set keys for increasing/decreasing pane size
        bind-key -r J resize-pane -D 5
        bind-key -r K resize-pane -U 5
        bind-key -r H resize-pane -L 5
        bind-key -r L resize-pane -R 5

        # Vim selection:
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

        # Auto updating tmux window name
        set-option -g status-interval 15
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#(basename "#{pane_current_path}")'

        # 256 colors support
        set -g default-terminal "screen-256color"

        # sane scrolling
        set -g mouse on

        # Getting ssh-agent to work correctly
        set -g update-environment "SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION"

        # setting colors properly
        set-option -sa terminal-overrides ',xterm-256color:RGB'

        set -g status off
    '';
    plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
    ];
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    # TODO: fix this later once I'm ready for linux
    # terminal = if isDarwin then "screen-256color" else "xterm-256color";
  };

}

