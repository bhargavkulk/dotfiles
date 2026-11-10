function fish_prompt
    set -l last_status $status
    # Prompt status only if it's not 0
    set -l stat
    if test $last_status -ne 0
        set stat (string join '' -- (set_color --reverse brred) ' ' "[$last_status]" ' ' (set_color normal))
    end

    # Prefix/replacement pairs for prompt paths. Add another pair to customize more.
    # Use "" as the replacement to remove a prefix.
    set -l prompt_path_substitutions \
        "$HOME/repos/" ""

    set -l prompt_path $PWD
    set -l custom_path
    set -l i 1
    while test $i -le (count $prompt_path_substitutions)
        set -l prefix $prompt_path_substitutions[$i]
        set -l replacement $prompt_path_substitutions[(math $i + 1)]
        if string match -q -- "$prefix*" "$prompt_path"
            set custom_path (string replace -- "$prefix" "$replacement" "$prompt_path")
            break
        end
        set i (math $i + 2)
    end

    if set -q custom_path[1]
        set prompt_path (prompt_pwd --dir-length=0 "$custom_path")
    else
        set prompt_path (prompt_pwd)
    end

    set -l vcs (fish_vcs_prompt)
    if test -n "$vcs"
        set vcs (string trim --left --chars ' ' -- "$vcs")
        set vcs (string join '' -- ' ' "$vcs" ' ')
    end
    string join '' -- (set_color --reverse brgreen) ' ' $prompt_path ' ' (set_color normal) $vcs $stat
    string join '' -- (set_color brgreen) '~> ' (set_color normal)
end
