# source /usr/share/cachyos-fish-config/cachyos-config.fish
# ~/.config/fish/config.fish - Streamlined Configuration with Fish Features

# =====================
# PATHing
# =====================
fish_add_path -Up ~/.local/bin ~/bin ~/.cargo/bin

if status is-interactive

    # =====================
    # 1. Terminal and Editor
    # =====================
    set -gx TERM xterm-256color # Use 256-color terminal
    set -gx EDITOR /usr/bin/nvim # Default editor
    set -gx VISUAL /usr/bin/nvim # Default visual editor

    set -gx fish_autosuggestion_enabled # Enable autosuggestions
    set -gx fish_syntax_highlighting_enabled # Enable syntax highlighting

    set -gx fish_greeting "" # Disable default Fish greeting

    # Standard navigation
    bind \e\[H beginning-of-line # Home key
    bind \e\[F end-of-line # End key
    bind \e\[3~ delete-char # Delete key
    bind \ct backward-kill-word # Ctrl+Backspace
    bind \el insert-last-word # Esc+. for last word of last command

    # Autosuggestions (Fish-like behavior)
    bind \e\[C forward-char # Right Arrow Key for accepting autosuggestions

    # =====================
    # Aliases
    # =====================
    alias cp="cp -i" # Confirm before overwriting something
    alias df="df -h" # Human-readable sizes
    alias free="free -m" # Show sizes in MB
    alias ls="ls --color=auto"
    alias ll="ls -lA --color=auto"
    alias lb="lsblk -o NAME,SIZE,FSTYPE,LABEL,PARTLABEL,MOUNTPOINT"
    # Replace ls with eza
    alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
    alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
    alias ll='eza -l --color=always --group-directories-first --icons' # long format
    alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
    alias l.="eza -a | grep -e '^\.'" # show only dotfiles

    # Git aliases
    alias lg='lazygit'
    alias gad="git add"
    alias gbr="git branch"
    alias gch="git checkout"
    alias gco="git commit -v"
    alias gdf="git diff"
    alias gfh="git fetch --prune"
    alias glg="git log --oneline -n 20"
    alias gmr="git merge"
    alias gph="git push"
    alias gpl="git pull"
    alias gsk="git stash --keep-index"
    alias gst="git status -bs"

    # =====================
    # Exports
    # =====================
    # Format man pages
    set -gx MANROFFOPT -c
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

    # Color man pages
    set -gx LESS_TERMCAP_mb (printf '\e[01;32m')
    set -gx LESS_TERMCAP_md (printf '\e[01;32m')
    set -gx LESS_TERMCAP_me (printf '\e[0m')
    set -gx LESS_TERMCAP_se (printf '\e[0m')
    set -gx LESS_TERMCAP_so (printf '\e[01;47;34m')
    set -gx LESS_TERMCAP_ue (printf '\e[0m')
    set -gx LESS_TERMCAP_us (printf '\e[01;36m')
    set -gx LESS -r

    # Syntax highlighting and autosuggestions (Fish has these built-in).

    # television A fast, portable and hackable fuzzy finder for the terminal.
    if type -q tv
        tv init fish | source
    end

    # zoxide (smarter directory navigation)
    if type -q zoxide
        zoxide init fish | source
    end

    # Starship prompt (modern and customizable, MUST be the last line)
    if type -q starship
        starship init fish | source
    end

    # =====================
    # Key bindings
    # =====================
    function fish_user_key_bindings
        bind \e\[A history-search-backward # Up Arrow Key
        bind \e\[B history-search-forward # Down Arrow Key
        if functions -q tv_shell_history
            bind \cr tv_shell_history # Ctrl+R for television history search
        else
            bind \cr history-search-backward # Fallback to built-in history search
        end
    end

    # =====================
    # Secrets
    # =====================
    if test -f ~/.config/fish/secrets.fish
        source ~/.config/fish/secrets.fish
    end

end
