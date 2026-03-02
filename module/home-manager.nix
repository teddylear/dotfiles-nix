{
  git-username,
  git-email,
  unstablePkgs,
}: {
  config,
  pkgs,
  ...
}: let
  inherit (pkgs) lib;

  enableOpenCode = git-username == "teddylear";
in {
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
    hurl
    atuin

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

  home.sessionPath =
    [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$PYENV_ROOT/bin"
      "$HOME/.pkenv/bin"
      "$HOME/.tfenv/bin"
      "/opt/homebrew/bin/"
      "$HOME/development/language/go/bin"
    ]
    ++ lib.optionals enableOpenCode [
      "$HOME/.opencode/bin"
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

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      update_check = false;
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

      if test -f "$HOME/local_fish_config.fish";
        source $HOME/local_fish_config.fish
      end
    '';

    functions = {
      gb = ''
        set target_branch (git branch | fzf --reverse | tr -d '[:space:]')
        git switch $target_branch
      '';

      p = ''
        set file (fzf --reverse --preview='bat --color always {}')
        nvim $file
      '';

      jjws = ''
        if not set -q argv[1]
            echo "usage: jjws <bookmark-name>" >&2
            return 2
        end

        set -l bookmark $argv[1]
        # TODO: update this to git/jj root.
        set -l cwd_name (basename (pwd))
        set -l ws_dir "$cwd_name:$bookmark"

        echo "🚀 Creating JJ workspace for bookmark: $bookmark"
        echo "📁 Target directory: ../$ws_dir"
        echo ""

        if jj workspace add "../$ws_dir" --name "$bookmark"
            echo ""
            echo "✅ Workspace created successfully for: $bookmark"
        else
            echo ""
            echo "❌ Failed to create workspace for: $bookmark" >&2
            return 1
        end


        set -l tmux_session "$cwd_name~$bookmark"
        tmux new-session -d -s "$tmux_session" -c "../$ws_dir"
        tmux move-window -s "$tmux_session:0" -t "$tmux_session:1"
        tmux rename-window -t "$tmux_session:1" "editor"
        # TODO: open vim here
        tmux new-window -t "$tmux_session:0" -n "Documents" -c "$HOME/Documents/"
        tmux new-window -t "$tmux_session:2" -n "shell" -c "../$ws_dir"
        tmux new-window -t "$tmux_session:3" -n "AI" -c "../$ws_dir"
        tmux new-window -t "$tmux_session:9" -n "DOTFILES" -c "$HOME/dotfiles-nix/"
        echo "✅ Created tmux session: $ws_dir"

        # TODO: Any local machine specific instrutions
      '';

      jjcl = ''
        if not set -q argv[1]
            echo "usage: jjcl <bookmark-name>" >&2
            return 2
        end

        set -l bookmark $argv[1]
        set -l cwd_name (basename (pwd))
        set -l ws_dir "../$cwd_name:$bookmark"

        echo "🧹 Cleaning up JJ workspace for: $bookmark"
        echo "📁 Target directory: $ws_dir"
        echo ""

        # Check directory exists
        if not test -d "$ws_dir"
            echo "❌ Directory does not exist: $ws_dir" >&2
            return 1
        end

        # Forget workspace
        if not jj workspace forget "$bookmark"
            echo "❌ Failed to forget workspace: $bookmark" >&2
            return 1
        end

        # Delete directory
        rm -rf "$ws_dir"

        echo "✅ Workspace removed: $bookmark and directory deleted: $ws_dir"
        tmux kill-session -t "$cwd_name~$bookmark"
        echo "✅ Tmux session `$cwd_name~$bookmark` removed"
      '';

      ts = ''
        set -l session (tmux list-sessions -F '#S' 2>/dev/null | fzf --reverse)
        or return

        if set -q TMUX
            tmux switch-client -t "$session"
        else
            tmux attach -t "$session"
        end
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
      jf = "jj git fetch";
      jn = "jj new";
      js = "jj st";
      ld = "lumen diff";
      gsw = "git switch";
      gsc = "git switch -c";
      gd = "git diff";
      gs = "git status";
      gp = "git pull";
      gps = "git push";
      gcm = "git commit -m";
      tsplit = "tmux split-window -h -p";
      vim = "nvim";
      gre = "git reset --hard HEAD";
      oldvim = "\\vim";
      cat = "bat";
      ll = "eza -l -g -a --icons";
      tmuxsession = "fish $HOME/tmux-session.fish";
      jd = "jj diff --git | delta --features=chameleon";
      jp = "jj git push --bookmark";
      jbs = {
        expansion = "jj bookmark set % -r @";
        setCursor = true;
      };
      jbc = {
        expansion = "jj bookmark create % -r @";
        setCursor = true;
      };
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
      # set-option -g automatic-rename on
      # set-option -g automatic-rename-format '#(basename "#{pane_current_path}")'
      set -g automatic-rename off
      set -g allow-rename off

      set-option -sg escape-time 10

      set -g default-terminal "screen-256color"
      set -g mouse on

      set -g update-environment "SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION"
      set-option -sa terminal-overrides ',xterm-256color:RGB'

      set -g default-command fish
      set -g status-left-length 100

      set -g @catppuccin_flavor "mocha"
      set -g allow-set-title off
      set -g window-status-format "#[fg=#11111b,bg=#{@thm_overlay_2}] #I "
      set -g window-status-current-format "#[fg=#11111b,bg=#{@thm_mauve}] #I "
    '';

    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.catppuccin
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
