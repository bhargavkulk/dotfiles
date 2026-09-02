;; -*- lexical-binding: t; -*-

(require 'modus-themes)

(modus-themes-register 'modus-australis)

(defvar modus-australis-palette
  (modus-themes-generate-palette
   `(
     (bg-main         "#FFFFFF")
     (bg-dim          "#F6F7FA")
     (fg-main         "#2E3440")
     (fg-dim          "#6E7F96")
     (fg-dim-alt      "#627C46")
     (border          "#6E7F96")
     (red             "#2E3440")
     (red-intense     "#2E3440")
     (red-faint       "#2E3440")
     (red-cooler      "#2E3440")
     (red-warmer      "#2E3440")
     (green           "#2E3440")
     (green-intense   "#2E3440")
     (green-faint     "#2E3440")
     (green-cooler    "#2E3440")
     (green-warmer    "#2E3440")
     (yellow          "#2E3440")
     (yellow-intense  "#2E3440")
     (yellow-faint    "#2E3440")
     (yellow-cooler   "#2E3440")
     (yellow-warmer   "#2E3440")
     (blue            "#2E3440")
     (blue-intense    "#2E3440")
     (blue-faint      "#2E3440")
     (blue-cooler     "#2E3440")
     (blue-warmer     "#2E3440")
     (magenta         "#2E3440")
     (magenta-intense "#2E3440")
     (magenta-faint   "#2E3440")
     (magenta-cooler  "#2E3440")
     (magenta-warmer  "#2E3440")
     (cyan            "#2E3440")
     (cyan-intense    "#2E3440")
     (cyan-faint      "#2E3440")
     (cyan-cooler     "#2E3440")
     (cyan-warmer     "#2E3440")
     (bg-added        "#FFFFFF")
     (fg-added        "#627C46")
     (bg-removed      "#FFFFFF")
     (fg-removed      "#B9555F")
     (bg-changed       "#FFFFFF")
     (fg-changed       "#996E1A")
     (bg-added-faint "#FFFFFF")
     (fg-added-faint "#627C46")
     (bg-removed-faint "#FFFFFF")
     (fg-removed-faint "#B9555F")
     (bg-completion "#F6F6F6")
     (underline-err    "#B9555F")
     (err    "#B9555F")
     (underline-warning "#996E1A")
     (warning "#996E1A")
     (underline-note    "#4F78A1")
     (keyword "#4F78A1")
     (fnname "#3A7D92")
     (rx-backslash      "#996E1A")
     (rx-construct      "#996E1A")
     (bg-mode-line-active "#F6F7FA")
     (bg-mode-line-inactive "#F6F7FA")
     )
   'cool)
  "Color definitions for modus-australis.")

(defconst modus-australis-palette-partial
  `((fringe bg-main)
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

(defcustom modus-australis-palette-overrides nil
  "Overrides for `modus-australis-palette'."
  :group 'nordic-night-themes
  :type '(repeat (list symbol (choice symbol string))))

(defconst modus-australis-custom-faces
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
    `(magit-diff-hunk-heading-highlight
      ((,c :inherit magit-diff-hunk-heading :inverse-video t)))
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
      ((,c :foreground ,"#B9593C" :inverse-video t)))
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
 'modus-australis
 'modus-nord-themes
 "Light, minimal, high-contrast theme built around the modus-themes and with the Nord color palette."
 'light
 'modus-australis-palette
 'modus-australis-palette-partial
 'modus-australis-palette-overrides
 'modus-australis-custom-faces)

(provide 'modus-australis-theme)
