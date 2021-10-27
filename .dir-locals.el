((nil . ((projectile-project-configure-cmd . "EDITOR='emacsclient -n -a false' make configure")
         (projectile-project-compilation-cmd . "make submodules")
         (projectile-project-test-cmd . "make test")
         (projectile-project-run-cmd . "make")
         (projectile-project-install-cmd . "make") ;; same as above
         (projectile-project-package-cmd . "make dist")))

 ;; NOTE: In order to maintian proper spacing of Org footnotes, you must redefine
 ;; the `org-footnote-sort' function to *not* insert a leading "\n" before new
 ;; footnote definitions.
 (org-mode . ((org-footnote-section . "Reference")
              (org-footnote-auto-label . t)
              (org-footnote-auto-adjust . t))))
