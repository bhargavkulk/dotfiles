;;; -*- lexical-binding: t -*-

;; - Emacs compile-command -------------------------------------------------------------------------

;; OCaml (and some other languages) use 0-indexed columns
(setopt compilation-first-column 0)

;; Scroll the compilation buffer to follow output
(setopt compilation-scroll-output t)

;; Skip warnings and info when navigating with next-error
(setopt compilation-skip-threshold 2)

;; Colorize compilatio-command buffer
(require 'ansi-color)

(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(defun compile-dwim ()
  "Run `project-compile' in a project, otherwise `compile'."
  (interactive)
  (if (project-current nil)
      (call-interactively #'project-compile)
    (call-interactively #'compile)))

(bind-key "<f5>" #'compile-dwim)

;; - Built-in config for developers ----------------------------------------------------------------

(use-package treesit
  :ensure nil
  :custom
  (treesit-enabled-modes
   '(python-ts-mode c-ts-mode c++-ts-mode))
  (treesit-font-lock-level 4))

(use-package project
  :ensure nil
  :custom
  (project-switch-commands 'project-find-file)
  (project-mode-line t)
  :hook
  ((prog-mode . electric-pair-mode)
   (prog-mode . hs-minor-mode)))

;; - Version Control -------------------------------------------------------------------------------

;; Highlight TODOs
(use-package hl-todo
  :custom-face
  (hl-todo ((t (:inverse-video t))))
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("TODO" . "#fa9441")
          ("NOTE" . "#a3be8c"))))

(use-package transient
  :ensure t)

;; Magit: best Git client to ever exist
(use-package magit
  :bind
  ("C-x g" . magit-status)
  (:map magit-status-mode-map
        ("P" . magit-push-current-to-upstream))
  :init
  (defun magit-dotfiles-status ()
    "Open Magit for the bare dotfiles repository and home worktree."
    (interactive)
    (let ((default-directory (expand-file-name "~/"))
          (process-environment
           (append (list (concat "GIT_DIR=" (expand-file-name "~/.dotfiles"))
                         (concat "GIT_WORK_TREE=" (expand-file-name "~/")))
                   process-environment)))
      (magit-status-setup-buffer default-directory))))

;; Show TODOs in magit buffer
(use-package magit-todos
  :ensure t
  :after magit
  :config (magit-todos-mode 1))

;; - Common file types -----------------------------------------------------------------------------

(use-package markdown-mode
  :hook ((markdown-mode . auto-fill-mode)))

(use-package yaml-mode)

(use-package json-mode)

(use-package web-mode
  :defer t
  :mode
  (("\\.mako\\'" . web-mode)))

(use-package rust-mode
  :defer t)

(use-package wgsl-mode
  :mode
  (("\\.wgsl\\'" . wgsl-mode)))

(use-package racket-mode
  :defer t
  :custom
  (racket-program "/Applications/Racket v9.1/bin/racket"))

(use-package auctex
  :defer t
  :ensure t)

(use-package cc-mode
  :ensure nil
  :bind
  (:map c++-mode-map
        ("C-c C-f" . ff-find-other-file))
  (:map c-mode-map
        ("C-c C-f" . ff-find-other-file)))

(use-package lean-mode
  :ensure (:host github
                 :repo "bhargavkulk/lean-mode"
                 :files (:defaults ("data" "data/*.json")))
  :demand t)

;; - Eglot, the built-in LSP client for Emacs ------------------------------------------------------

(use-package flymake
  :ensure nil
  :hook
  (prog-mode . flymake-mode)
  :bind
  (:map flymake-mode-map
        ("M-n" . flymake-goto-next-error)
        ("M-p" . flymake-goto-prev-error)
        ("C-c ! l" . flymake-show-buffer-diagnostics)
        ("C-c ! p" . flymake-show-project-diagnostics))
  :config
  (defvar-keymap init/flymake-repeat-map
    :repeat t
    "n" #'flymake-goto-next-error
    "p" #'flymake-goto-prev-error)
  :custom
  (eldoc-documentation-strategy #'eldoc-documentation-compose)
  (eldoc-display-functions '(eldoc-display-in-echo-area))
  (flymake-start-on-flymake-mode t)
  (flymake-start-on-save-buffer t)
  (flymake-no-changes-timeout 0.5)
  (flymake-wrap-around t))

(use-package eglot
  :ensure nil
  :bind
  ("C-c e e" . eglot)
  ("C-c e r" . eglot-rename)
  ("C-c e ." . eglot-code-actions)
  ("C-c e c" . eglot-reconnect)
  ("C-c e k" . eglot-shutdown)
  :hook
  (((python-mode) . eglot-ensure))
  :custom
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t)              ; activate Eglot in referenced non-project files
  (eglot-highlight-symbol nil)
  (eglot-autoshutdown t)
  (eglot-prefer-plaintext t)
  (eldoc-display-functions
   '(eldoc-display-in-echo-area eldoc-display-in-buffer))
  :config
  ;; Avoid changing line heights if your font is wonky. See
  ;; https://github.com/joaotavora/eglot/discussions/1492
  (add-to-list 'eglot-ignored-server-capabilities :semanticTokensProvider)
  (setopt eglot-code-action-indicator "h")
  (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event
  (add-to-list 'eglot-server-programs
               `((python-ts-mode python-mode) .
                 ("uv" "run" "ty" "server"))))

;; You can set various options for each language server. For
;; example, you can raise the number of completions surfaced by a
;; given langauge server to Emacs:
;; (setopt eglot-workspace-configuration
;;     '((haskell (maxCompletions . 100))
;;       (elixir  (maxCompletions . 100))))

;; - Autoformat ------------------------------------------------------------------------------------

(use-package apheleia
  :defer t
  :hook (prog-mode . apheleia-mode)
  :config
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  ;; Prettier has no parser for Mako templates, even when they are
  ;; edited with `web-mode'.
  (add-to-list 'apheleia-mode-alist '("\\.mako\\'" . nil))
  (setf (alist-get 'rust-mode apheleia-formatters)
        '("rustfmt" "--edition" "2024" "--quiet" "--emit" "stdout"))
  (setf (alist-get 'clang-format apheleia-formatters)
        '("clang-format" "--style=file" "-assume-filename"
          (or (apheleia-formatters-local-buffer-file-name)
              (apheleia-formatters-mode-extension) ".c"))))

;; - ghostel ---------------------------------------------------------------------------------------

(use-package ghostel
  :defer t)
