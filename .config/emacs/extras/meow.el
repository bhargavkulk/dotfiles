;; -*- lexical-binding: t; -*-

;; - Meow Mode -------------------------------------------------------------------------------------

(defun +meow-join ()
  "Joins line with line below it."
  (interactive)
  (meow-join -1)
  (meow-kill))

(defun meow-clipboard-replace ()
  "Replace current selection with yank.

This command supports `meow-selection-command-fallback'."
  (interactive)
  (meow--with-selection-fallback
   (let ((select-enable-clipboard t))
     (when (meow--allow-modify-p)
       (when-let* ((s (string-trim-right (current-kill 0 t) "\n")))
         (meow--delete-region (region-beginning) (region-end))
         (set-marker meow--replace-start-marker (point))
         (meow--insert s))))))

(defun meow-shell-command ()
  "Run project-shell-command' if in a project else `shell-command'."
  (interactive)
  (if (project-current)
      (call-interactively #'project-shell-command)
    (call-interactively #'shell-command)))

(defun meow-quit-dwim ()
  "Quit current window or buffer."
  (interactive)
  (cond ((region-active-p)
         (meow--cancel-selection))
        ((one-window-p)
         (user-error "Only one window"))
        ((or (window-dedicated-p)
             (string-match-p "\\*.*\\*" (buffer-name)))
         (quit-window))
        (t
         (delete-window))))

(use-package meow
  :ensure t
  :config
  (defun meow-setup ()
    (meow-motion-define-key
     '(":" . execute-extended-command)
     '("Q" . delete-other-windows)
     '("q" . meow-quit-dwim)
     '("j" . meow-next)
     '("k" . meow-prev)
     '("[" . scroll-down-command)
     '("]" . scroll-up-command)
     '("{" . beginning-of-buffer)
     '("}" . end-of-buffer)
     '("<escape>" . ignore))

    ;; Meta actions
    (meow-normal-define-key
     '("#" . ispell-word)
     '("G" . meow-grab)
     '("b" . meow-swap-grab)
     '("B" . meow-sync-grab)
     '("v" . meow-visit)
     '("n" . meow-search)
     '("!" . meow-shell-command)
     '(":" . execute-extended-command)
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("q" . meow-quit-dwim)
     '("Q" . delete-other-windows)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("o" . meow-append)
     '("O" . meow-open-below)
     '("(" . kmacro-start-macro-or-insert-counter)
     '(")" . kmacro-end-or-call-macro)
     '("<escape>" . ignore))

    ;; Movement
    (meow-normal-define-key
     '("-" . meow-reverse)
     '("%" . goto-match-paren)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("a" . meow-back-word)
     '("A" . meow-back-symbol)
     '("s" . meow-next-word)
     '("S" . meow-next-symbol)
     '("g" . goto-transient)
     '("[" . backward-paragraph)
     '("]" . forward-paragraph)
     '("{" . beginning-of-buffer)
     '("}" . end-of-buffer)
     '("$" . end-of-line)
     '("^" . back-to-indentation))

    ;; Selection
    (meow-normal-define-key
     '("f" . meow-find)
     '("F" . (lambda ()
               (interactive)
               (let ((current-prefix-arg -1))
                 (call-interactively 'meow-find))))
     '("t" . meow-till)
     '("T" . (lambda ()
               (interactive)
               (let ((current-prefix-arg -1))
                 (call-interactively 'meow-till))))
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("<" . meow-beginning-of-thing)
     '(">" . meow-end-of-thing)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("e" . meow-line)
     '("Z" . meow-join))

    ;; Edits
    (meow-normal-define-key
     '("z" . +meow-join))

    ;; Selection Verbs
    (meow-normal-define-key
     '("x" . meow-delete)
     '("X" . meow-backward-delete)
     '("d" . meow-kill)
     '("D" . meow-clipboard-kill)
     '("y" . meow-save)
     '("Y" . meow-clipboard-save)
     '("p" . meow-yank)
     '("P" . meow-clipboard-yank)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("c" . meow-change)
     '("r" . meow-replace)
     '("R" . meow-clipboard-replace)
     '(";" . comment-dwim)
     '("\\" . fill-paragraph)))

  (setq-default meow-replace-state-name-list
                '((normal . "NOR")
                  (motion . "MTN")
                  (keypad . "KPD")
                  (insert . "INS")
                  (beacon . "BCN")))
  (meow-setup-indicator)
  (dolist
      (state
       '((View-mode . normal)
         (comint-mode . normal)
         (fundamental-mode . normal)
         (message-mode . normal)
         (emacs-lisp-mode . normal)
         (eshell-mode . insert)
         (shell-mode . insert)
         (term-mode . insert)
         (help-mode . normal)
         (helpful-mode . normal)))
    (add-to-list 'meow-mode-state-list state))
  (defun advice-remove-meow-remap (orig-fun &rest args)
    "Advice to remove the remap entry from the keymap returned by foo."
    (let ((keymap (apply orig-fun args)))
      (if-let ((remap (assq 'remap keymap)))
          (delq remap keymap)
        keymap)))

  (advice-add #'meow--keypad-get-keymap-for-describe :around #'advice-remove-meow-remap)
  (meow-setup)
  (meow-global-mode 1)
  :custom
  (meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-char-thing-table
   '((?r . round)
     (?s . square)
     (?c . curly)
     (?' . string)
     (?b . buffer)
     (?p . paragraph)
     (?l . line)
     (?d . defun)))
  (meow-keypad-leader-dispatch "C-c")
  (meow-keypad-ctrl-meta-prefix ?y))

(use-package meow-tree-sitter
  :ensure t
  :config
  (meow-tree-sitter-register-thing ?. '("function" "class"))
  (meow-tree-sitter-register-thing ?\; '("comment")))
