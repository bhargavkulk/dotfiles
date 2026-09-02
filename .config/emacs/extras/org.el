;;; -*- lexical-binding: t -*-

;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at https://mozilla.org/MPL/2.0/.

;; - Personal Org Mode configuration ---------------------------------------------------------------

(use-package org
  :defer t
  :ensure nil
  :hook ((org-mode . auto-fill-mode)
         (org-mode . flyspell-mode)
         (org-capture-after-finalize . bh/org-capture-delete-quick-note-frame))
  :config
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)           ; Click on files to open them
  :custom
  (org-edit-src-indentation 0)
  (org-fontify-whole-block-delimiter-line t)
  (org-ellipsis (if (char-displayable-p ?▾) " ▾" " ..."))
  (org-startup-folded 'content)
  (org-startup-with-inline-images t)
  (org-startup-indented t)
  (org-special-ctrl-o t)
  (org-support-shift-select nil)
  (org-hide-emphasis-markers t)
  (org-return-follows-link t))

(use-package orgonomic
  :ensure (:repo "https://github.com/aaronjensen/emacs-orgonomic")
  :defer t
  :hook (org-mode . orgonomic-mode))

;; - Denote ----------------------------------------------------------------------------------------

(use-package denote
  :ensure t
  :demand t
  :config
  (denote-rename-buffer-mode)
  (put 'denote-file-type 'safe-local-variable 'symbolp)
  :hook
  (dired-mode . denote-dired-mode)
  :custom
  (denote-front-matter-components-present-even-if-empty-value
   '(title date identifier))
  (denote-org-front-matter
   "#+title:      %1$s
#+date:       %2$s
#+identifier: %4$s
#+signature:  %5$s
\n")
  (denote-file-type 'org)
  (denote-directory "~/site/content/garden"))

(use-package denote-org
  :ensure t
  :after denote)

;; - Bramhic scripts input method ------------------------------------------------------------------

(require 'quail)
(quail-define-package
 "iso-postfix" "UTF-8" "InR<" t
 "Input method for Indian languages. Diacritics are added through postfix."
 nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("aa" "ā")     ; आ, ಆ
 ("ii" "ī")     ; ई, ಈ
 ("uu" "ū")     ; ऊ, ಊ
 ("r," "ṛ")     ; ऋ, ಋ
 ("m." "ṃ")     ; ं, ಂ
 ("h." "ḥ")     ; ः, ಃ
 ("n;" "ṅ")     ; ङ, ಙ
 ("n~" "ñ")     ; ञ, ಞ
 ("t." "ṭ")     ; ट, ಟ
 ("th." ["ṭh"]) ; ठ, ಠ
 ("d." "ḍ")     ; ड, ಡ
 ("dh." ["ḍh"]) ; ढ, ಢ
 ("n." "ṇ")     ; ण, ಣ
 ("l." "ḷ")     ; ळ, ಳ
 ("sh" "ś")     ; श, ಶ
 ("s." "ṣ")     ; ष, ಷ
 ("gy" ["jñ"])) ; ज्ञ, ಜ್ಞ
