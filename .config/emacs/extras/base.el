;;; -*- lexical-binding: t -*-

;; - visual stuff ----------------------------------------------------------------------------------

(use-package perfect-margin
  :ensure t
  :custom
  (perfect-margin-visible-width 128)
  :config
  (perfect-margin-mode t))

(use-package popwin
  :demand t
  :config
  (popwin-mode 1))

;; NOTE enable when needed
;;(use-package virtual-auto-fill
;;  :config
;;  (with-eval-after-load 'markdown-mode
;;    (add-hook 'markdown-mode-hook #'virtual-auto-fill-mode)))

;; - Motion aids -----------------------------------------------------------------------------------

;; NOTE have not used this, need to use it more
(use-package avy
  :bind (("C-c g c" . avy-goto-char-timer)
         ("C-c g g" . avy-goto-line)
         :map isearch-mode-map
         ("C-j" . avy-isearch))
  :custom
  (avy-timeout-seconds 2)
  (avy-all-windows nil)
  (avy-background nil)
  (avy-style 'pre))

;; - Consult: Misc. enhanced commands --------------------------------------------------------------

(use-package consult
  :after vertico
  :bind (([remap switch-to-buffer] . consult-buffer)
         ("C-x b" . consult-buffer)
         ([remap bookmark-jump] . consult-bookmark)
         ([remap yank-pop] . consult-yank-pop))
  :custom
  (consult-narrow-key "<")
  (xref-show-xrefs-function #'consult-xref))

;; - Minibuffer and completion ---------------------------------------------------------------------

;; Vertico: better vertical completion for minibuffer commands
(use-package vertico
  :init
  (vertico-mode))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("M-DEL" . vertico-directory-delete-word))
  :custom
  (vertico-cycle t))

;; Marginalia: annotations for minibuffer
(use-package marginalia
  :config
  (marginalia-mode))

;;; Corfu: better tab-complete UI
(use-package corfu
  :bind
  (:map corfu-map
        ("SPC" . corfu-insert-separator)
        ("M-p" . corfu-popupinfo-scroll-up)
        ("M-n" . corfu-popupinfo-scroll-down)
        ("M-d" . corfu-popupinfo-toggle))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode 1)
  (corfu-history-mode)
  :custom
  (corfu-quit-no-match t)
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-popupinfo-delay 0.2)
  (corfu-popupinfo-max-width 70)
  (corfu-popupinfo-max-height 20))

(use-package corfu-history
  :ensure nil
  :after corfu
  :config
  (with-eval-after-load 'savehist
    (cl-pushnew 'corfu-history savehist-additional-variables))
  (corfu-history-mode t))

;; Fancy completion-at-point functions; there's too much in the cape package to configure here; dive
;; in when you're comfortable!
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package eshell
  :ensure nil
  :init
  (defun bedrock/setup-eshell ()
    ;; Something funny is going on with how Eshell sets up its keymaps; this is a work-around to
    ;; make C-r bound in the keymap
    (keymap-set eshell-mode-map "C-r" 'consult-history))
  :hook ((eshell-mode . bedrock/setup-eshell)))

;; Eat: Emulate A Terminal
(use-package eat
  :custom
  (eat-term-name "xterm")
  :config
  (eat-eshell-mode)                     ; use Eat to handle term codes in program output
  (eat-eshell-visual-command-mode))     ; commands like less will be handled by Eat

;; Orderless: powerful completion style
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; - Better Emacs Help -----------------------------------------------------------------------------

;; Helpful: better describe
(use-package helpful
  :bind (([remap describe-function] . helpful-callable)
         ([remap describe-command] . helpful-command)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-key] . helpful-key)
         ([remap describe-symbol] . helpful-symbol)
         ([remap display-local-help] . helpful-at-point)
         :map emacs-lisp-mode-map
         ("C-h ." . helpful-at-point)
         :map helpful-mode-map
         ("q" . quit-window)))

;; - Dired stuff -----------------------------------------------------------------------------------

;; dired-k: show git status in dired buffers

(use-package dired-k
  :ensure t
  :after dired
  :config
  (advice-add 'dired-k--highlight-by-date :override #'ignore)
  (add-hook 'dired-initial-position-hook #'dired-k)
  (add-hook 'dired-after-readin-hook #'dired-k-no-revert)
  :custom
  (dired-k-padding 1))
