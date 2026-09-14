# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -gx EDITOR "emacsclient -nw -a ''"

if test -d /home/linuxbrew/.linuxbrew # Linux
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
    set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
else if test -d /opt/homebrew # MacOS
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
    set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
end

fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

! set -q MANPATH; and set MANPATH ''
set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH

! set -q INFOPATH; and set INFOPATH ''
set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH

fish_add_path ~/.cargo/bin/
fish_add_path ~/bin/
fish_add_path ~/.local/bin/
fish_add_path /Users/bhargavkk/Library/pnpm/bin

function fish_prompt
    set -l last_status $status
    # Prompt status only if it's not 0
    set -l stat
    if test $last_status -ne 0
        set stat (string join '' -- (set_color --reverse brred) ' ' "[$last_status]" ' ' (set_color normal))
    end
    set -l vcs (fish_vcs_prompt)
    if test -n "$vcs"
        set vcs (string trim --left --chars ' ' -- "$vcs")
        set vcs (string join '' -- (set_color --reverse blue) ' ' "$vcs" ' ' (set_color normal))
    end
    string join '' -- (set_color --reverse brgreen) ' ' (prompt_pwd) ' ' (set_color normal) $vcs $stat
    string join '' -- (set_color brgreen) '~> ' (set_color normal)
end

function fish_greeting
    fish_logo
end

function localhost
    set -l dir (test (count $argv) -ge 1; and echo $argv[1]; or echo ".")
    set -l port (test (count $argv) -ge 2; and echo $argv[2]; or echo "8000")
    python3 -m http.server $port -d $dir
end

function conf
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $argv
end
complete -c conf -w git

function __conf_git_complete
    set -lx GIT_DIR "$HOME/.dotfiles"
    set -lx GIT_WORK_TREE "$HOME"
    set -l commandline (commandline --current-process)
    set commandline (string replace -r '^conf($| )' 'git$1' -- $commandline)
    complete -C -- $commandline
end
complete -c conf -a '(__conf_git_complete)'

function magit
    set -l git_root (git rev-parse --show-toplevel)
    emacsclient -nw -a emacs -e "(progn (magit-status \"$git_root\") (delete-other-windows))"
end

abbr -a em 'emacsclient -nw'
