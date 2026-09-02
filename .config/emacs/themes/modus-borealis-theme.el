;; -*- lexical-binding: t; -*-

(require 'modus-themes)

(modus-themes-register 'modus-borealis)

(defvar modus-borealis-palette
  (modus-themes-generate-palette
   `(
     (bg-main          "#000000")
     (bg-dim           "#171A20")
     (fg-main          "#ECEFF4")
     (fg-dim           "#616E88") ;757575
     (fg-dim-alt       "#A3BE8C") ; cac9c0
     (border           "#616E88")
     (red              "#ECEFF4")
     (red-intense      "#ECEFF4")
     (red-faint        "#ECEFF4")
     (red-cooler       "#ECEFF4")
     (red-warmer       "#ECEFF4")
     (green            "#ECEFF4")
     (green-intense    "#ECEFF4")
     (green-faint      "#ECEFF4")
     (green-cooler     "#ECEFF4")
     (green-warmer     "#ECEFF4")
     (yellow           "#ECEFF4")
     (yellow-intense   "#ECEFF4")
     (yellow-faint     "#ECEFF4")
     (yellow-cooler    "#ECEFF4")
     (yellow-warmer    "#ECEFF4")
     (blue             "#ECEFF4")
     (blue-intense     "#ECEFF4")
     (blue-faint       "#ECEFF4")
     (blue-cooler      "#ECEFF4")
     (blue-warmer      "#ECEFF4")
     (magenta          "#ECEFF4")
     (magenta-intense  "#ECEFF4")
     (magenta-faint    "#ECEFF4")
     (magenta-cooler   "#ECEFF4")
     (magenta-warmer   "#ECEFF4")
     (cyan             "#ECEFF4")
     (cyan-intense     "#ECEFF4")
     (cyan-faint       "#ECEFF4")
     (cyan-cooler      "#ECEFF4")
     (cyan-warmer      "#ECEFF4")
     (bg-completion    "#434C5E")
     (underline-err    "#BF616A")
     (err              "#BF616A")
     (underline-warning "#EBCB8B")
     (warning           "#EBCB8B")
     (underline-note    "#81A1C1")
     (keyword           "#81A1C1")
     (fnname            "#88C0D0")
     (rx-backslash      "#EBCB8B")
     (rx-construct      "#EBCB8B")
     (bg-mode-line-active "#171A20")
     (bg-mode-line-inactive "#171A20")
     )
   'cool)
  "Color definitions for modus-borealis.")

(defconst modus-borealis-palette-partial
  '((bg-added "#46503e")
    (fg-added "#A3BE8C")
    (bg-added-faint "#46503e")
    (bg-added-refine "#022405")
    (bg-removed "#512e31")
    (fg-removed "#BF616A")
    (bg-removed-faint "#512e31")
    (bg-removed-refine "#240205")
    (bg-changed "#ffdfa9")
    (fg-changed "#553d00")
    (bg-changed-faint "#ffdfa9")
    (bg-changed-refine "#fac090")
    (fringe bg-main)
    (bg-line-number-inactive bg-main)
    (bg-line-number-active bg-main)
    (border-mode-line-active bg-mode-line-active)
    (border-mode-line-inactive bg-mode-line-inactive)
    (bg-paren-expression bg-completion)
    (bg-hover-secondary  bg-completion)
    (bg-region           fg-main)
    (fg-region           bg-main)
    (bg-search-current   bg-completion)
    (fg-search-current   fg-main)
    (bg-search-lazy      bg-completion)
    (fg-search-lazy      fg-main)
    (bg-active-argument  bg-completion)
    (fg-active-argument  fg-main)
    (bg-search-static    bg-completion)
    (fg-search-static    fg-main)
    (bg-diff-context     bg-main)
    (docstring           comment)
    (string              fg-dim-alt)
    (preprocesser        comment)
    (bg-removed-fringe   bg-removed)
    (bg-added-fringe     bg-added)
    (bg-changed-fringe   bg-changed)
    (variable-use        fg-main)
    (fnname-call         fg-main)
    (bracket             comment)
    (delimiter           comment)
    (fg-heading-0        fg-main)
    (fg-heading-1        fg-main)
    (fg-heading-2        fg-main)
    (fg-heading-3        fg-main)
    (fg-heading-4        fg-main)
    (fg-heading-5        fg-main)
    (fg-heading-6        fg-main)
    (fg-heading-7        fg-main)
    (fg-heading-8        fg-main)
    (bg-prose-code       bg-dim)
    (bg-prose-verbatim   bg-dim)))

(defcustom modus-borealis-palette-overrides nil
  "Overrides for `modus-borealis-palette'."
  :group 'nordic-night-themes
  :type '(repeat (list symbol (choice symbol string))))

(defconst modus-borealis-custom-faces
  '(
    `(font-lock-type-face
      ((,c :inherit modus-themes-slant :foreground ,type)))
    `(font-lock-builtin-face
      ((,c :inherit modus-themes-slant :foreground ,builtin)))
    `(font-lock-preprocessor-face
      ((,c :inherit modus-themes-slant :foreground ,comment)))
    `(font-lock-negation-char-face
      ((,c :foreground ,fg-main)))
    `(font-lock-regexp-grouping-backslash
      ((,c :foreground ,rx-backslash)))
    `(font-lock-regexp-grouping-construct
      ((,c :foreground ,rx-construct)))
    `(whitespace-line
      ((,c :background ,bg-space :inherit modus-themes-bold)))
    `(magit-diff-context
      ((,c :foreground ,fg-main)))
    `(diff-hunk-header
      ((,c :inherit modus-themes-bold :background ,bg-inactive)))
    `(vdiff-closed-fold-face
      ((,c :inherit modus-themes-bold :background ,bg-inactive)))
    `(magit-diff-hunk-heading
      ((,c :background ,bg-inactive)))
    `(magit-diff-hunk-heading-highlight
      ((,c :inherit modus-themes-bold :background ,bg-active)))
    `(diff-refine-added
      ((,c :foreground ,fg-added :background ,bg-added-refine)))
    `(diff-refine-removed
      ((,c :foreground ,fg-removed :background ,bg-removed-refine)))
    `(diff-refine-changed
      ((,c :foreground ,fg-changed :background ,bg-changed-refine)))
    `(vdiff-addition-face
      ((,c :foreground ,fg-added :background ,bg-added :extend t)))
    `(vdiff-change-face
      ((,c :foreground ,fg-changed :background ,bg-changed :extend t)))
    `(vdiff-subtraction-face
      ((,c :foreground ,fg-removed :background ,bg-removed :extend t)))
    `(vdiff-subtraction-fringe-face
      ((,c :foreground ,bg-removed-fringe :background ,bg-removed-fringe)))
    `(vdiff-refine-added
      ((,c :foreground ,fg-added :background ,bg-added-refine)))
    `(vdiff-refine-changed
      ((,c :foreground ,fg-changed :background ,bg-changed-refine)))
    `(magit-diff-added-indicator
      ((,c :foreground ,fg-added :background ,bg-added-refine)))
    `(magit-diff-removed-indicator
      ((,c :foreground ,fg-removed :background ,bg-removed-refine)))
    `(magit-diff-base-indicator
      ((,c :foreground ,fg-changed :background ,bg-changed-refine)))
    `(magit-section-heading
      ((,c :foreground ,fg-main :weight bold)))
    `(magit-hash
      ((,c :foreground ,fg-dim)))
    `(dired-k-untracked
      ((,c :foreground "#fa9441" :weight bold)))
    `(dired-k-ignored
      ((,c :foreground ,fg-dim :weight bold)))
    `(dired-k-commited
      ((,c :foreground "#a3be8c" :weight bold)))
    `(dired-k-added
      ((,c :foreground "#a3be8c" :weight bold)))
    `(dired-k-modified
      ((,c :foreground "#BF616A" :weight bold)))
    `(isearch
      ((,c :background ,bg-search-current :foreground ,fg-search-current
           :underline ,fg-search-current)))
    `(show-paren-match
      ((,c :inherit default :underline ,fg-main)))
    `(diff-hl-delete
      ((,c :background ,bg-removed-fringe :foreground ,bg-removed-fringe)))
    `(diff-hl-insert
      ((,c :background ,bg-added-fringe :foreground ,bg-added-fringe)))
    `(diff-hl-changed
      ((,c :background ,bg-changed-fringe :foreground ,bg-changed-fringe)))
    `(hl-todo
      ((,c :foreground ,"#D08770" :inverse-video t)))
    `(flymake-error
      ((,c :foreground ,bg-main :background ,underline-err
           :inherit (modus-themes-slant modus-themes-bold))))
    `(flymake-note
      ((,c :underline (:color ,underline-note))))
    `(eglot-diagnostic-tag-unnecessary-face
      ((,c :underline (:color ,underline-note))))
    `(flymake-warning
      ((,c :underline (:color ,underline-warning))))
    `(font-latex-warning-face
      ((,c :inherit modus-themes-bold :foreground ,fg-dim)))
    `(avy-goto-char-timer-face
      ((,c :inherit (bold modus-themes-reset-soft)
           :background ,bg-search-lazy :foreground ,fg-search-lazy)))
    `(avy-lead-face
      ((,c :inherit (bold modus-themes-reset-soft)
           :background ,bg-search-current :foreground ,fg-search-current)))
    `(avy-lead-face-0
      ((,c :inherit (bold modus-themes-reset-soft)
           :background ,bg-search-current :foreground ,fg-search-current)))
    `(avy-lead-face-1
      ((,c :inherit (bold modus-themes-reset-soft)
           :background ,bg-search-current :foreground ,fg-search-current)))
    `(avy-lead-face-2
      ((,c :inherit (bold modus-themes-reset-soft)
           :background ,bg-search-current :foreground ,fg-search-current)))
    `(font-lock-warning-face
      ((,c :inherit default)))
    `(modus-themes-completion-selected
      ((,c :inherit bold
           :background ,bg-main
           :foreground unspecified
           :underline t
           :weight unspecified)))
    `(marginalia-modified
      ((,c :foreground ,fg-main)))
    `(org-checkbox
      ((,c :inherit modus-themes-fixed-pitch :foreground ,bg-main)))
    `(org-checkbox-statistics-done
      ((,c :foreground ,bg-main)))
    `(org-checkbox-statistics-todo
      ((,c :foreground ,bg-main))))
  "Deep, direct face customizations that differ substantially from Modus")

(modus-themes-theme
 'modus-borealis
 'modus-nord-themes
 "Dark, minimal, high-contrast theme built around the modus-themes and with the Nord color palette."
 'dark
 'modus-borealis-palette
 'modus-borealis-palette-partial
 'modus-borealis-palette-overrides
 'modus-borealis-custom-faces)

(provide 'modus-borealis-theme)
