{
  git-username,
  git-email,
  unstablePkgs,
}: {
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rustup
    ripgrep
    scooter
    bat
    jq
    tree
    delta
    sd
    neofetch
    mcfly
    fd
    gh
    awscli2
    unzip
    _1password-cli
    pipenv
    fzf
    just
    nodejs_20
    ansible
    stow
    jira-cli-go
    httpstat
    bottom
    luajit
    luajitPackages.luarocks
    eza
    uv
    jujutsu
    neovim

    gopls
    terraform-ls
    lua-language-server
    marksman
    nodePackages.bash-language-server

    alejandra
    stylua

    delve
    llvmPackages.lldb

    bacon
    air
  ];

  home.file.".ssh/config".source = ././config/ssh-agent-config;
  home.file."tmux-session.fish" = {
    source = ././scripts/tmux-session.fish;
    executable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    MCFLY_KEY_SCHEME = "vim";
    MCFLY_RESULTS = "20";
    FZF_DEFAULT_COMMAND = "rg --files --follow --hidden --glob=!.git";
    TMUX_WIN_PATH = "$HOME/code";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    MANWIDTH = "999";
    PYENV_ROOT = "$HOME/.pyenv";
    SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    PIPENV_SHELL = "${pkgs.fish}/bin/fish";
    HOMEBREW_NO_AUTO_UPDATE = "1";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$PYENV_ROOT/bin"
    "$HOME/.pkenv/bin"
    "$HOME/.tfenv/bin"
    "/opt/homebrew/bin/"
    "$HOME/development/language/go/bin"
  ];

  home.stateVersion = "23.11";

  programs.git = {
    enable = true;

    settings = {
      color.ui = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      bash.showDirtyState = true;
      branch.sort = "-committerdate";
      github.user = git-username;

      user = {
        name = git-username;
        email = git-email;
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

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

  programs.fish = {
    enable = true;

    shellInit = ''
      set fish_greeting

      pyenv init - | source
      mcfly init fish | source

      if test -f "$HOME/local_fish_config.fish";
        source $HOME/local_fish_config.fish
      end
    '';

    shellAliases = {
      jf = "jj git fetch";
      jn = "jj new";
      js = "jj st";
    };

    functions = {
      gb = ''
        set target_branch (git branch | fzf --reverse | tr -d '[:space:]')
        git switch $target_branch
      '';

      p = ''
        set file (fzf --reverse --preview='bat --color always {}')
        nvim $file
      '';

      fish_prompt = "string join '' -- (set_color 50fa7b) (prompt_pwd --full-length-dirs 2) (set_color bd93f9) (fish_git_prompt) (set_color normal) '\n > '";

      fish_user_key_bindings = "fish_vi_key_bindings";

      propen = ''
        set git_commit_text (git log -1 --pretty=%B)
        gh pr create --draft --title "$git_commit_text" --body "$git_commit_text"
        gh pr view -w
      '';

      tfclean = ''
        rm -rf .terraform
        rm plan.out
      '';

      tfsetup = ''
        echo "==> Cleaning up directory"
        tfclean
        echo "==> Running init"
        terraform init
        echo "==> Running plan"
        terraform plan -out=plan.out
      '';
    };

    shellAbbrs = {
      tsplit = "tmux split-window -h -p";
      vim = "nvim";
      gre = "git reset --hard HEAD";
      oldvim = "\\vim";
      cat = "bat";
      gsw = "git switch";
      gsc = "git switch -c";
      gd = "git diff";
      gs = "git status";
      gp = "git pull";
      gps = "git push";
      gcm = "git commit -m";
      ll = "eza -l -g -a --icons";
      tmuxsession = "fish $HOME/tmux-session.fish";
      jd = "jj diff --git | delta --features=chameleon";
      jp = "jj git push --bookmark";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.go = {
    enable = true;
    env = {
      GOPATH = "development/language/go";
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-w
      bind-key C-w send-prefix

      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind '"' new-window -c $TMUX_WIN_PATH

      bind t choose-tree

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r H resize-pane -L 5
      bind-key -r L resize-pane -R 5

      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      set-option -g status-interval 15
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#(basename "#{pane_current_path}")'
      set-option -sg escape-time 10

      set -g default-terminal "screen-256color"
      set -g mouse on

      set -g update-environment "SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION"
      set-option -sa terminal-overrides ',xterm-256color:RGB'

      set -g default-command fish
      set -g status off
    '';

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
    ];

    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
  };

  home.file.".jjconfig.toml".text = ''
    [user]
    name = "${git-username}"
    email = "${git-email}"

    [ui]
    paginate = "never"
    default-command = "shortlog"

    [aliases]
    shortlog = ["log", "-n", "5"]
    rebaseall = ["jj", "rebase", "-s", "'all:roots(trunk..@)'", "-d", "trunk"]

    [git]
    default-remote = "origin"
    push-new-bookmarks = true
  '';
}
