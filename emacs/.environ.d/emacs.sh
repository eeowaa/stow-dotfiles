## Requires: emacs
alias ec='emacsclient'
woman() { emacsclient -ne "(woman \"$1\")"; }
