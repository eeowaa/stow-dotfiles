((org-mode (org-footnote-section . "Reference")
           (org-footnote-auto-label . t)
           (org-footnote-auto-adjust . t)))

;; NOTE: In order to maintian proper spacing of Org footnotes, you must redefine
;; the `org-footnote-sort' function to *not* insert a leading "\n" before new
;; footnote definitions.
