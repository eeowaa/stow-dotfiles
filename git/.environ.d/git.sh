#!/bin/sh
## Requires: fzf

# Thin wrapper for git command
git() {
    case $1 in
    cd)
        shift
        git_cd ${1+"$@"} ;;
    *)
        command git ${1+"$@"} ;;
    esac
}

# Wrapper for cd with useful git-related shortcuts
git_cd() {
    usage="\
usage: git cd [jump]
   or: git cd <path>
   or: git cd git
   or: git cd common
   or: git cd top
   or: git cd super
   or: git cd worktree <branch>
"
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
        tab='	'

        # Temporary file I/O is more predictably reliable in this complex case
        # than variable assignment from command substitution
        tmpfile=`mktemp`

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
        filepath=`cat "$tmpfile"`
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
        test $# -eq 2 || {
            echo >&2 'Usage: git cd worktree <branch>'
            return 1
        }
        target=`git worktree list --porcelain | awk '
    $1 == "worktree" {
        worktree = $2
    }
    $1 == "branch" && gensub(/.*\//, "", 1, $2) == branch {
        print worktree
        exit
    }' branch=$2` ;;
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
