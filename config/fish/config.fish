if status is-interactive
    zoxide init fish --cmd cd | source

    set fish_greeting
    fish_vi_key_bindings

    set -Ux EDITOR 'nvim'
    set -Ux VISUAL 'launch-editor-gui'
   
    alias ls="eza --icons=always --no-quotes -l"
    alias lsa="eza --icons=always --no-quotes -l -a"
    alias ld="eza --icons=always --no-quotes -l -D"
    alias lda="eza --icons=always --no-quotes -l -D -a"
    alias lff="eza --icons=always --no-quotes -l -f"
    alias lfa="eza --icons=always --no-quotes -l -f -a"
    alias checkupdates="checkupdates; update-waybar 8; update-waybar 9"

    alias sudo="sudo -E"
    alias sudoedit='sudo launch-editor'
    alias vim='launch-editor'
    alias v='launch-editor'
    alias cat='bat'
    alias cls='command clear'

    # Kanagawa Fish shell theme
    set -l foreground DCD7BA normal
    set -l selection 2D4F67 brcyan
    set -l comment 727169 brblack
    set -l red C34043 red
    set -l orange FF9E64 brred
    set -l yellow C0A36E yellow
    set -l green 76946A green
    set -l purple 957FB8 magenta
    set -l cyan 7AA89F cyan
    set -l pink D27E99 brmagenta

    # Syntax Highlighting Colors
    set -g fish_color_normal $foreground
    set -g fish_color_command $cyan
    set -g fish_color_keyword $pink
    set -g fish_color_quote $yellow
    set -g fish_color_redirection $foreground
    set -g fish_color_end $orange
    set -g fish_color_error $red
    set -g fish_color_param $purple
    set -g fish_color_comment $comment
    set -g fish_color_selection --background=$selection
    set -g fish_color_search_match --background=$selection
    set -g fish_color_operator $green
    set -g fish_color_escape $pink
    set -g fish_color_autosuggestion $comment

    # Completion Pager Colors
    set -g fish_pager_color_progress $comment
    set -g fish_pager_color_prefix $cyan
    set -g fish_pager_color_completion $foreground
    set -g fish_pager_color_description $comment

    set fish_prompt_pwd_dir_length 0

    function new_line_after_exec --on-event fish_postexec
        if [ $argv[1] != 'clear' ] && [ $argv[1] != 'cls' ]
            echo ''
        end
    end


end
