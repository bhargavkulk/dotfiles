# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx PROJECT_PATH ~/repos
set -gx EDITOR emacsclient -c -a ''

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
        set stat (set_color brred)"[$last_status]"(set_color normal)
    end
    echo (set_color --reverse brgreen) (prompt_pwd) (set_color normal) (fish_vcs_prompt)
    string join '' -- $stat (set_color brgreen) '$ ' (set_color normal)
end

function localhost
    set -l dir (test (count $argv) -ge 1; and echo $argv[1]; or echo ".")
    set -l port (test (count $argv) -ge 2; and echo $argv[2]; or echo "8000")
    python3 -m http.server $port -d $dir
end

function conf
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $argv
end

abbr -a em 'emacs -nw'
