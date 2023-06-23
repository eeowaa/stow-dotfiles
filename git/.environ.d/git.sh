#!/bin/sh
## Requires: fzf

# Thin wrapper for git command
git() {
    case $1 in
    cd)
        shift
        git_cd ${1+"$@"} ;;
    shopt)
        shift
        git_shopt ${1+"$@"} ;;
    *)
        command git ${1+"$@"} ;;
    esac
}

# Wrapper for cd with useful git-related shortcuts
git_cd() {
    local usage="\
usage: git cd [jump]
   or: git cd <path>
   or: git cd git
   or: git cd common
   or: git cd top
   or: git cd super
   or: git cd worktree [<branch>]
"
    local target=
    case $1 in
    -h|--help)
        echo "$usage"
        return $? ;;
    ''|jump)
        # This subcommand requires a nonstandard program
        which fzf >/dev/null || {
            echo >&2 'Error: missing command: fzf'
            return 1
        }

        # Literal tab characters are more predictably reliable than "\t"
        local tab='	'

        # Temporary file I/O is more predictably reliable in this complex case
        # than variable assignment from command substitution
        local tmpfile=`mktemp`

        # `git-ls-tree` is used instead of `git-ls-files` because the latter
        # will not output directories if they contain no files (i.e. if they
        # only contain other directories). Unfortunately, `git-ls-tree` does
        # not accept a `--recurse-submodules` flag, so `git-submodule foreach`
        # must be used to find directories in submodules.
        {
            git ls-tree --full-tree -rt HEAD :/
            git submodule --quiet foreach "
                echo \"<mode> tree <object>$tab\$sm_path\"
                git ls-tree --full-tree -rt HEAD | sed \"s|$tab|$tab\$sm_path/|\"
            "
        } | awk '$2 == "tree"' | cut -f2 | fzf >"$tmpfile" || {
            rm -f "$tmpfile"
            return 1
        }
        local filepath=`cat "$tmpfile"`
        rm -f "$tmpfile"

        target=`git rev-parse --show-toplevel`/$filepath ;;
    git)
        target=`git rev-parse --git-dir` ;;
    common)
        target=`git rev-parse --git-common-dir` ;;
    top)
        target=`git rev-parse --show-toplevel` ;;
    super)
        target=`git rev-parse --show-superproject-working-tree` ;;
    worktree)
        case $# in
        1)
            which fzf >/dev/null || {
                echo >&2 'Error: missing command: fzf'
                return 1
            }
            local branch=`git worktree list --porcelain | awk '
            $1 == "branch" {
                print gensub(/^refs\/heads\//, "", 1, $2)
            }' | fzf`
            [ "$branch" ] || {
                echo >&2 'Error: empty selection'
                return 1
            }
            git_cd worktree "$branch"
            return $? ;;
        2)
            target=`git worktree list --porcelain | awk '
            $1 == "worktree" {
                worktree = $2
            }
            $1 == "branch" && gensub(/^refs\/heads\//, "", 1, $2) == branch {
                print worktree
                exit
            }' branch=$2` ;;
        *)
            echo >&2 'Usage: git cd worktree [<branch>]'
            return 1 ;;
        esac ;;
    *)
        case $1 in
        :\(top\)*|:/*|/*)
            # Convert absolute path to relative
            target=\
`git rev-parse --path-format=relative --show-toplevel`\
`echo "$1" | sed -e 's|^:(top)|/|' -e 's|^:\{0,1\}/|/|'` ;;
        *)
            target=$1 ;;
        esac
    esac

    test -d "$target" || {
        echo >&2 'Error: Target directory does not exist'
        return 1
    }
    cd "$target"
}

# Enable or disable git integration features in the current shell
git_shopt() {
    local usage="\
usage: git shopt [-su] [optname ...]
options: alias
"
    local mode=
    case $1 in
    -h|--help)
        echo "$usage"
        return $? ;;
    -s) mode=set ;;
    -u) mode=unset ;;
    *)  echo >&2 "$usage"
        return 1 ;;
    esac
    shift
    for optname
    do
        case $optname in
        alias)
            git_shopt_alias $mode ;;
        *)
            echo >&2 "Invalid option: $optname" ;;
        esac
    done
}
git_shopt_alias() {
    case $1 in
    set)
        # TODO: Model after magit transient keys
        while read name value
        do
            echo "$name: $value"
            alias "$name=$value"
            _git_shopt_aliases=$_git_shopt_aliases${_git_shopt_aliases:+' '}$name
        done <<EOF ;;
ga  git add
gc  git commit
gd  git diff
gf  git fetch
gg  git graph --all
gp  git push
gs  git status
EOF
    unset)
        # Enable word splitting in zsh
        local nosplit=
        [ "$ZSH_VERSION" ] && [[ ! -o shwordsplit ]] && {
            setopt shwordsplit
            nosplit=X
        }

        local shadow=
        for name in $_git_shopt_aliases
        do
            unalias $name
            shadow=`which $name 2>/dev/null`
            [ "$shadow" ] && echo "$name: $shadow"
        done
        _git_shopt_aliases=

        # Restore setting for word splitting
        [ "$nosplit" ] && unsetopt shwordsplit ;;
    esac
}
