;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Mal Sharman"
      user-mail-address "malcolmsharman@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

(setq doom-font (font-spec :family "monospace" :size 20 :weight 'semi-light)
       doom-variable-pitch-font (font-spec :family "sans" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;; Mac customizations
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'control)
  (setq mac-right-option-modifier 'super)
  )

(defalias 'qrr 'query-replace-regexp)

;(setq org-roam-directory "~/Dropbox/org/roam")

;(setq deft-directory "~/Dropbox/Notebooks/000 - Inbox"
;      deft-new-file-format "markdown"
;      deft-extensions '("md", "txt"))


;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  )
(setq copilot-node-executable "~/.nodenv/versions/20.11.0/bin/node")

(after! god-mode
  (global-set-key (kbd "<f3>") 'god-mode-all)
  (global-set-key (kbd "C-<f3>") 'god-mode-all)
)

(use-package! obsidian
  :ensure t
  :demand t
  :config
  (obsidian-specify-path "~/Documents/sync-personal")
  (global-obsidian-mode t)
  :custom
  ;; This directory will be used for `obsidian-capture' if set.
  (obsidian-inbox-directory "000 - Inbox")
  ;; Create missing files in inbox? - when clicking on a wiki link
  ;; t: in inbox, nil: next to the file with the link
  ;; default: t
                                        ;(obsidian-wiki-link-create-file-in-inbox nil)
  ;; The directory for daily notes (file name is YYYY-MM-DD.md)
  (obsidian-daily-notes-directory "Daily Notes")
  ;; Directory of note templates, unset (nil) by default
                                        ;(obsidian-templates-directory "Templates")
  ;; Daily Note template name - requires a template directory. Default: Daily Note Template.md
                                        ;(setq obsidian-daily-note-template "Daily Note Template.md")
  :bind (:map obsidian-mode-map
              ;; Replace C-c C-o with Obsidian.el's implementation. It's ok to use another key binding.
              ("C-c C-o" . obsidian-follow-link-at-point)
              ;; Jump to backlinks
              ("C-c C-b" . obsidian-backlink-jump)
              ;; If you prefer you can use `obsidian-insert-link'
              ("C-c C-l" . obsidian-insert-wikilink)))

(server-start)
(require 'org-protocol)
;; Org-capture configuration for bookmarks
(after! org
  (setq org-capture-templates
        '(("L" "Link" entry
           (file+headline "~/Dropbox/org/bookmarks.org" "Bookmarks")
           "* %?\n:PROPERTIES:\n:URL: %:link\n:ADDED: %U\n:END:\n\n%:description\n"
           :empty-lines 1)
          ("b" "Bookmark" entry
           (file+headline "~/Dropbox/org/bookmarks.org" "Bookmarks")
           "* %?\n:PROPERTIES:\n:URL: %x\n:ADDED: %U\n:END:\n\n"
           :empty-lines 1)
          ("m" "Meeting" plain
           (file (lambda () (format "~/Dropbox/org/meetings/%s-meeting.org" (format-time-string "%Y%m%d-%H%M"))))
           "#+TITLE: %^{Meeting Title}\n#+DATE: %<%Y-%m-%d %H:%M>\n#+ATTENDEES: %^{Attendees}\n\n* Agenda\n%?\n\n* Notes\n\n* Action Items\n\n"
           :unnarrowed t))))
