#!/bin/sh

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
usage: git cd git
   or: git cd common
   or: git cd top
   or: git cd super
   or: git cd worktree <branch>
"
    case $1 in
    -h|--help)
        echo "$usage"
        return $? ;;
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
    esac

    test -d "$target" || {
        echo >&2 'Error: Target directory does not exist'
        return 1
    }
    cd "$target"
}
