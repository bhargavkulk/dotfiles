;;; -*- lexical-binding: t -*-

;; (setenv "TERMINFO" nil)

(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)

;; Guardrail
(when (< emacs-major-version 31)
  (error "Emacs Bedrock only works with Emacs 31 and newer; you have version %s"
         emacs-major-version))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

;; Start emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

(defun open-init-file ()
  "Open init file."
  (interactive)
  (find-file user-init-file))

(defun comment-rule ()
  "Turn the current line into a comment rule."
  (interactive)
  (comment-normalize-vars)
  (let* ((text (string-trim (thing-at-point 'line t)))
         (starter (if (and (= (length comment-start) 1)
                           (> comment-add 0))
                      (concat comment-start
                              (make-string comment-add
                                           (string-to-char comment-start)))
                    comment-start))
         (prefix (comment-padright starter 0))
         (base (format "%s- %s " prefix text)))
    (delete-region (line-beginning-position) (line-end-position))
    (insert base)
    (when (< (current-column) fill-column)
      (insert (make-string (- fill-column (current-column)) ?-)))))

;; Move emacs set settings elsewhere
(setopt custom-file (expand-file-name "custom.el" user-emacs-directory))
(and (file-readable-p custom-file) (load custom-file))

;; - Elpaca Bootstrap ------------------------------------------------------------------------------

(load-file (expand-file-name "elpaca-bootstrap.el" user-emacs-directory))

;; - Basic Settings --------------------------------------------------------------------------------

(setopt inhibit-splash-screen t)          ; Turn off the splash screen; changes *scratch* to default
;; Only open the default Dired buffer when Emacs was started without a file.
(setopt initial-buffer-choice
        (unless (seq-some (lambda (arg)
                            (not (string-prefix-p "-" arg)))
                          (cdr command-line-args))
          "~/repos"))

;; Automatically reread from disk if the underlying file changes by using the OS file change
;; notification interface rather than repeatedly polling to see if there are changes.
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(setopt auto-revert-use-notify nil)
(global-auto-revert-mode)

;; Save history of minibuffer: future invocations will have recently-used selections sorted first
(savehist-mode)

;; Keep track of recent files and cursor positions
(recentf-mode)
(save-place-mode)

;; Fix archaic defaults
(setopt sentence-end-double-space nil)  ; Why is this even a thing
(setopt use-short-answers t)            ; Make all prompts use `y'/`n' instead of `yes'/`no'

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Don't litter file system with *~ backup files; put them all inside ~/.emacs.d/backup or wherever
(let ((backup-dir (expand-file-name "emacs-backup/" user-emacs-directory)))
  (setopt backup-directory-alist `(("." . ,backup-dir))))

;; MacOS specific stuff
(defconst macos?
  (eq system-type 'darwin))

(when macos?
  (setopt ns-use-thin-smoothing t)      ; Not sure what this does, but should be good?
  (setopt insert-directory-program "/opt/homebrew/bin/gls")) ; Stop `dired` from screaming

;; Use my favorite font (until I buy the license for Berkeley Mono)
(when (member "Ioskeley Mono" (font-family-list)) ;
  (set-face-attribute 'fixed-pitch nil
                      :font (font-spec :family "Ioskeley Mono"
                                       :size 14))
  (set-face-attribute 'default nil
                      :font (font-spec :family "Ioskeley Mono"
                                       :size 14)))

(when (member "Ioskeley Mono" (font-family-list))
  (set-face-attribute 'variable-pitch nil
                      :font (font-spec :family "Ioskeley Mono"
                                       :size 14)))

(when (memq system-type '(darwin))
  (set-fontset-font t nil "SF Pro Display" nil 'append))

;; Keep the kill-ring clean
(setopt kill-do-not-save-duplicates t)
(setopt save-interprogram-paste-before-kill t)

;; Saner whitespace handling
(setq-default require-final-newline t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; - Discovery aids --------------------------------------------------------------------------------

;; `which-key': shows a popup of available keybindings when typing a long key sequence (e.g. C-x
;; ...)
(use-package which-key
  :ensure nil
  :config
  (which-key-mode))

;; - Minibuffer/completion settings ----------------------------------------------------------------

(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; Try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different completion styles

(setopt completion-auto-help 'always)   ; Open completion always
(setopt completions-max-height 20)      ; This is an arbitrary value
(setopt completions-format 'one-column) ; Makes it easier to scroll
(setopt completions-group t)            ; Groups candidates (don't know what this does)

;; Eager completion setup: show *Completions* buffer immediately
(setopt completion-auto-select 'second-tab) ; Much more eager
(setopt completion-eager-display t)         ; Show the completions buffer immediately
(setopt completion-eager-update t)          ; Update display as-you-type
(setopt completion-ignore-case t)           ; Ignore case for completion

;; Automatic inline completion previews
(completion-preview-mode)

;; make TAB work like shell
(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

;; Hide irrelevant commands from M-x
(setopt read-extended-command-predicate
        #'command-completion-default-include-p)

;; - Interface enhancements/defaults ---------------------------------------------------------------

;; Mode line information
(setopt line-number-mode t)                 ; Show current line in modeline
(setopt column-number-mode t)               ; Show column as well
(setopt mode-line-collapse-minor-modes nil) ; nil default; set to `t' to hide minor modes

(setopt x-underline-at-descent-line nil)         ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t) ; Make switching buffers more consistent
(setopt use-dialog-box nil)                      ; Prefer minibuffer prompts

(setopt show-trailing-whitespace nil)     ; By default, don't underline trailing spaces
(setopt indicate-buffer-boundaries 'left) ; Show buffer top and bottom in the margin

;; Enable horizontal scrolling
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

;; Default indentation settings
(setopt indent-tabs-mode nil)           ; Only use spaces to perform indentation
(setopt tab-width 4)

;; I don't like word wrap
(setq-default truncate-lines t)

;; Misc. UI tweaks
(blink-cursor-mode -1)

;; Makes it easier to repeat commands; `C-x o C-x o' becomes `C-x o o'
(setopt repeat-exit-timeout 2)
(repeat-mode 1)

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)

;; Show matching delimiters
(setopt show-paren-delay 0)
(setopt show-paren-mode t)
(setopt show-paren-context-when-offscreen 'overlay)

;; Highlight lines longer than 100 characters
(setopt whitespace-line-column 100)
(setopt whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode)

;; Change fill column to a 100. Note `setq-default' here.
(setq-default fill-column 100)

;; Delete files by moving to trash
(setopt delete-by-moving-to-trash t)

;; Follow symlinks in dired
(setopt vc-follow-symlinks t)

;; - Keybindings -----------------------------------------------------------------------------------

;; bind-key is probably the easiest way to bind stuff
(require 'bind-key)

(defun split-and-follow-horizontally ()
  "Split window below, and also move cursor to new window."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

(defun split-and-follow-vertically ()
  "Split window to the right, and also move cursor to new window."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(defun beginning-of-defun-dwim ()
  (interactive)
  (if (and (fboundp 'treesit-beginning-of-defun)
           (bound-and-true-p treesit-primary-parser))
      (treesit-beginning-of-defun)
    (beginning-of-defun)))

(defun end-of-defun-dwim ()
  (interactive)
  (if (and (fboundp 'treesit-end-of-defun)
           (bound-and-true-p treesit-primary-parser))
      (treesit-end-of-defun)
    (end-of-defun)))

;; Global Key Bindings
(bind-keys
 ([remap capitalize-word] . capitalize-dwim) ; These are better than the defaults
 ([remap downcase-word] . downcase-dwim)
 ([remap upcase-word] . upcase-dwim)
 ([remap set-fill-column] . find-file)  ; I never have to use `set-fill-column'
 ("C-x C-b" . switch-to-buffer)         ; I never have to list all buffers
 ("C-x d" . dired)           ; I almost always have to open the current directory
 ("C-x C-d" . dired-jump)
 ("C-x F" . find-file-other-window)
 ("C-x 2" . split-and-follow-horizontally) ; When I create new split I want to jump to it
 ("C-x 3" . split-and-follow-vertically)
 ("<S-return>" . default-indent-new-line)  ; new-line with indent is useful to have
 ("M-o" . other-window))

(unbind-key "M-z")                  ; Remove `zap-to-char'. Very dangerous command to press
(unbind-key "C-x C-z")              ; `suspend-frame' is annoying to hit by accident again
(unbind-key "C-<wheel-up>")         ; I use trackpad very often, so I don't want textscale to change
(unbind-key "C-<wheel-down>")

;; - Theme -----------------------------------------------------------------------------------------

(use-package modus-themes
  :demand t
  :ensure t
  :bind ("<f7>" . modus-themes-toggle)
  :init
  (defun my-modus-derivatives-activate-themes (directory)
    "Activate all themes in DIRECTORY.
This makes all Modus derivatives available to commands such as
`modus-themes-select' if `modus-themes-include-derivatives-mode' is
enabled."
    (let* ((files (directory-files directory :full-path "-theme\\.el"))
           (names (mapcar
                   (lambda (file)
                     (let ((base (file-name-base file)))
                       (intern (replace-regexp-in-string "-theme" "" base))))
                   files)))
      (mapc #'modus-themes-activate names)))

  (let ((themes (locate-user-emacs-file "themes/")
                ))
    (add-to-list 'custom-theme-load-path themes)
    (my-modus-derivatives-activate-themes themes))
  :config
  (modus-themes-include-derivatives-mode)
  (load-theme 'modus-borealis t)
  :custom
  (modus-themes-variable-pitch-ui t)
  (modus-themes-bold-constructs t)
  (modus-themes-italic-constructs t)
  (modus-themes-to-toggle '(modus-borealis modus-australis)))

;; - MacOS shell stuff -----------------------------------------------------------------------------

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; - Dired -----------------------------------------------------------------------------------------

(use-package dired
  :ensure nil
  :custom
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-isearch-filenames 'dwim)
  (dired-auto-revert-buffer #'dired-directory-changed-p)
  (dired-free-space nil)
  (dired-listing-switches "-AGFhlv --group-directories-first")
  :hook
  (dired-mode . dired-hide-details-mode))

;; - ISearch ---------------------------------------------------------------------------------------

(use-package isearch
  :ensure nil
  :bind (:map isearch-mode-map
              ("C-." . #'isearch-forward-thing-at-point)
              ("C-g" . #'isearch-cancel)
              ([remap beginning-of-buffer] . #'isearch-beginning-of-buffer)
              ([remap end-of-buffer] . #'isearch-end-of-buffer))
  :config
  (defvar-keymap my/isearch-repeat-map
    :repeat t
    "s" #'isearch-repeat-forward
    "r" #'isearch-repeat-backward)
  :custom
  (isearch-allow-motion t)
  (isearch-allow-scroll t)
  (search-highlight t)
  (isearch-lazy-highlight t)
  (isearch-lazy-count t)
  (lazy-count-prefix-format "(%s/%s) ")
  (lazy-count-suffix-format nil)
  (isearch-repeat-on-direction-change t)
  (isearch-wrap-pause 'no-ding))

;; - Extras ----------------------------------------------------------------------------------------

;; UI/UX enhancements mostly focused on minibuffer and autocompletion interfaces
(load-file (expand-file-name "extras/base.el" user-emacs-directory))

;; Packages for software development
(load-file (expand-file-name "extras/dev.el" user-emacs-directory))

;; Vim-bindings in Emacs (meow-mode configuration)
(load-file (expand-file-name "extras/meow.el" user-emacs-directory))

;; Org-mode configuration
(load-file (expand-file-name "extras/org.el" user-emacs-directory))

(setq gc-cons-threshold 800000)
