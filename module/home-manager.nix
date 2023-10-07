{ pkgs, ... }:

{
  home.packages = with pkgs; [
      # cli tools
      rustup
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
      _1password
      oh-my-zsh
      neovim
      # NOTE: Add eza when it's available
      # eza

      # Lua and Neovim build stuff
      luajitPackages.luarocks-nix
      cmake
      gettext
      ninja

  ];

  home.file.".config/alacritty/alacritty.yml".source = ././config/alacritty.yml;
  home.file.".config/nvim".source = ./config/nvim;
  home.file."tmux-session.sh" = {
    source = ././scripts/tmux-session.sh;
    executable = true;
  };

  # Later for linux
  # home.file.".config/i3/config".source = ././config/i3-config;
  # home.file.".config/compton.conf".source = ././config/compton.conf;

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    MCFLY_KEY_SCHEME= "vim";
    MCFLY_RESULTS = "20";
    FZF_DEFAULT_COMMAND = "rg --files --follow --hidden --glob=\!.git";
    TMUX_WIN_PATH = "$HOME/code";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    MANWIDTH = "999";
    PYENV_ROOT = "$HOME/.pyenv";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$PYENV_ROOT/bin"
    "$HOME/.pkenv/bin"
    "$HOME/.tfenv/bin"
  ];
  home.stateVersion = "23.05";

  # copying altf4's delta and most of git config
  programs.git = {
    delta = {
      enable = true;
      options = {
        chameleon = {
          dark = true;
          line-numbers = true;
          side-by-side = true;
          keep-plus-minus-markers = true;
          syntax-theme = "Nord";
          file-style = "#434C5E bold";
          file-decoration-style = "#434C5E ul";
          file-added-label = "[+]";
          file-copied-label = "[==]";
          file-modified-label = "[*]";
          file-removed-label = "[-]";
          file-renamed-label = "[->]";
          hunk-header-style = "omit";
          line-numbers-left-format = " {nm:>1} │";
          line-numbers-left-style = "red";
          line-numbers-right-format = " {np:>1} │";
          line-numbers-right-style = "green";
          line-numbers-minus-style = "red italic black";
          line-numbers-plus-style = "green italic black";
          line-numbers-zero-style = "#434C5E italic";
          minus-style = "bold red";
          minus-emph-style = "bold red";
          plus-style = "bold green";
          plus-emph-style = "bold green";
          zero-style = "syntax";
          blame-code-style = "syntax";
          blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
          blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
        };
        features = "chameleon";
        side-by-side = true;
      };
    };

    enable = true;

    extraConfig = {
      color.ui = true;
      # commit.gpgsign = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };

     # userEmail = ${git-email};
     # userName = ${git-username};
     extraConfig.github.user = "teddylear";
     userEmail = "teddylear";
     userName = "20077627+teddylear@users.noreply.github.com";
  };


  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };

    shellAliases = {
      vim = "nvim";
      oldvim = "\vim";
      tfclean="rm -rf .terraform; rm plan.out";
      cat = "bat";
      p = "nvim `fzf --reverse --preview=\"bat --color always {}\"`";
      gsw = "git switch";
      gsc = "git switch -c";
      gs = "git status";
      gr = "git restore";
      gp = "git pull";
      gps = "git push";
      gcm = "git commit -m";
      ll = "eza -l -g -a --icons";
      tmuxsession = "zsh $TMUX_SCRIPT_PATH";
    };

    initExtra = ''
        bindkey -v
        bindkey '^R' history-incremental-search-backward

        eval "$(mcfly init zsh)"
        eval "$(pyenv init -)"

        tfsetup() {
            echo "==> Cleaning up directory"
            tfclean
            echo "==> Running init"
            terraform init
            echo "==> Running plan"
            terraform plan -out=plan.out
        }

        if [ -f "$HOME/tmux-session.sh" ]
        then
            export TMUX_SCRIPT_PATH="$HOME/tmux-session.sh"
        else
            export TMUX_SCRIPT_PATH="$HOME/shell_config/tmux-session.sh"
        fi

        # From: https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load/
        timezsh() {
          shell=\$\{1-$SHELL\}
          for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
        }

        # From Thorsten Ball for using github cli
        pr() {
          if type gh &> /dev/null; then
            gh pr view -w
          else
            echo "gh is not installed"
          fi
        }

        propen() {
          if type gh &> /dev/null; then
            local git_commit_text=$(git log -1 --pretty=%B)
            gh pr create --draft --title $git_commit_text --body $git_commit_text
            pr
          else
            echo "gh is not installed"
          fi
        }

        # Adding local config file for things that cant be checked into git
        # Putting at the end of the file to override any unnecessary aliases
        if test -f "$HOME/local_zsh_config.zsh"; then
          source $HOME/local_zsh_config.zsh
        fi
    '';
  };

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

