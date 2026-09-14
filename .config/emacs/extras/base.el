;;; -*- lexical-binding: t -*-

;; - visual stuff ----------------------------------------------------------------------------------

(use-package perfect-margin
  :ensure t
  :custom
  (perfect-margin-visible-width 128)
  :config
  (perfect-margin-mode t))

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
              ("S-DEL" . vertico-directory-delete-word))
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
