*** git-vimdiff ***

Command Reference: {{{

  - 2do: Obtain chunk from $LOCAL (top-left)
  - 3do: Obtain chunk from $REMOTE (top-right)
  - 4dp: Put chunk to $MERGED (bottom-left)
  - ]c:  Next diff chunk
  - [c:  Previous diff chunk

}}}
Window arrangement: {{{

  +------------------------------------+-------------------------------------+
  |                                    |                                     |
  | File Path:       $LOCAL            | File Path:        $REMOTE           |
  | Git Commit Ref:  HEAD              | Git Commit Ref:   MERGE_HEAD        |
  | Git Index Stage: 2                 | Git Index Stage:  3                 |
  | Vim Buffer:      2                 | Vim Buffer:       3                 |
  |                                    |                                     |
  +------------------------------------+-------------------------------------+
  |                                    |                                     |
  | File Path:       $MERGED           | File Path:        git-vimdiff help  |
  | Git Commit Ref:  unstaged          | Git Commit Ref:   n/a               |
  | Git Index Stage: 0 (after merge)   | Git Index Stage:  n/a               |
  | Vim Buffer:      4                 | Vim Buffer:       5                 |
  |                                    |                                     |
  +--------------------------------------------------------------------------+

}}}
Hidden buffer for $BASE: {{{

  - File Path:       $BASE
  - Git Commit Ref:  $(git merge-base HEAD MERGE_HEAD)
  - Git Index Stage: 1
  - Vim Buffer:      1

}}}
Notes and hints: {{{

  - The $BASE buffer is hidden to preserve screen real estate and to simplify
    the interface. Use CTRL-^ in the bottom window to jump between $MERGED and
    $BASE, or use :b1 from anywhere to open $BASE.

  - From $MERGED, use 2do and 3do to obtain diff chunks from $LOCAL and
    $REMOTE, respectively. Use [range]diffget [2|3] to obtain chunks over a
    given range.  From $LOCAL or $REMOTE, use 4dp to put diff chunks into
    $MERGED. Use [range]diffput 4 to put chunks in a given range.

  - The contents of buffers 1 through 3 are populated from the blob objects
    in the git index corresponding to :1:<path>, :2:<path>, and :3:<path>.
    These index stages respectively correspond to blobs in the database:
    $(git merge-base HEAD MERGE_HEAD):<path>, HEAD:<path>, and MERGE_HEAD:<path>.

  - To finalize the merge, save buffer 4 and quit Vim normally. To abandon the
    merge, quit Vim using :cq!, which will signal to Git to ignore the results
    (at least when mergetool.trustExistCode is set to true, which it is in my
    config).

}}}
