;;; init.el --- Hanzelik's Emacs Configuration -*- lexical-binding: t; -*-
;;
;; Copyright (c) 2021 Matthew Hanzelik
;;
;; Author: Matthew Hanzelik <mrhanzelik@gmail.com>
;; URL: https://github.com/hanzelik/emacs.d
;; Keywords: emacs

;; This file is not part of GNU Emacs.

;;; Commentary:

;; My personal Emacs configuration. A lot of it is bassed off of
;; Bozhidar's Emacs configuration (https://github.com/bbatsov/emacs.d/)

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'package)


(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; Update the package metadata if the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(setq user-full-name "Matthew Hanzelik"
      user-mail-address "mrhanzelik@gmail.com")

;; Load newest byte code
(setq load-prefer-newer t)

;; Reduce garbage collection, making it happen ever 50MB
;; of allocated data
(setq gc-cons-threshold 50000000)

;; Warn when Emacs opens a file larger than 100MB
(setq large-file-warning-threshold 100000000)

;; Disable autosave file
(setq auto-save-default nil)

;; Quit Emacs even if there are running processess
(setq confirm-kill-process nil)

;; Disable the toolbar/menubar/scrollbar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Disable blinking cursor
(blink-cursor-mode -1)

;; Disable bell ring
(setq ring-bell-function 'ignore)

;; Disable startup screen
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

;; Better scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; Better modeline settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; Enabley y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; Better frame title, showing the buffer name
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Wrap lines at 80 chars
(setq-default fill-column 80)

;;  Revert buffers when underlying files are change externally
(global-auto-revert-mode t)

;; Setup UTF-8 coding system
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Enable smart tab
(setq tab-always-indent 'complete)

;; Enable commands that are disabled by default
(put 'erase-buffer 'disabled nil)

;; Change the global font to Terminus
(add-to-list 'default-frame-alist '(font . "Terminus 12"))
(set-face-attribute 'default nil :font "Terminus 12")

;; Enable if graphical issues on startup
;; (add-hook 'after-init-hook 'redraw-display)

;; Move all auto-saves to $HOME/.saves
(setq backup-directory-alist `(("." . "~/.saves")))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Built-in packages
(use-package paren
  :config
  (show-paren-mode +1))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package hl-line
  :config
  (global-hl-line-mode +1))

(use-package org
  :config
  (setq org-src-preserve-indentation t)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t))))

;; Beginning of user-added packages
(use-package async
  :ensure t
  :diminish async-mode
  :init (dired-async-mode 1))

(use-package diminish
  :ensure t)

(use-package linum-relative
  :ensure t
  :diminish linum-relative-mode
  :config
  (setq linum-relative-backend 'display-line-numbers-mode)
  (linum-relative-global-mode))

(use-package abbrev
  :diminish abbrev-mode
  :config
  (setq save-abbrevs 'silently)
  (setq-default abbrev-mode t))

(use-package spaceline
  :ensure t
  :config
  (spaceline-helm-mode 1)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (spaceline-spacemacs-theme)
;;  (set-face-background 'powerline-active1 "#990099")
;;  (set-face-background 'powerline-active2 "#990099")
  (set-face-background 'spaceline-evil-normal "#3cc342")
  (set-face-background 'spaceline-evil-insert "#2596da")
  (set-face-background 'spaceline-evil-visual "#e67619")
  (set-face-background 'spaceline-evil-replace "#cc3f33")
  (set-face-background 'spaceline-evil-emacs "#ba25da"))

(use-package modus-themes
  :ensure t
  :init
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs nil
	modus-themes-region '(bg-only no-extend))

  (modus-themes-load-themes)
  :config
  (modus-themes-load-vivendi))

;; (use-package spacemacs-theme
;;   :defer t
;;   :init
;;   (load-theme 'spacemacs-dark t))

;;(load-theme 'wheatgrass t)

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-leader
  :ensure t
  :after evil
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")
  (evil-leader/set-key
   "f" 'find-file
   "b" 'switch-to-buffer
   "k" 'kill-this-buffer
   "i" 'imenu
   "p" 'projectile-find-dir
   "m" 'magit-status
   "s" 'split-window-vertically
   "v" 'split-window-right)
  (evil-leader/set-key-for-mode 'rustic-mode
    "y" 'lsp-ui-peek-find-definitions
    "u" 'lsp-ui-peek-find-references)
  (evil-leader/set-key-for-mode 'clojure-mode
    "e" 'eval-last-sexp)
  (evil-leader/set-key-for-mode 'lisp-mode
    "e" 'sly-eval))

(use-package evil-collection
  :after evil
  :ensure t
  :diminish evil-collection-unimpaired-mode
  :config
  (evil-collection-init))

(use-package projectile
  :ensure t
  :init
  (setq projectile-project-search-path '("~/devel/" "~/repos/")))

(use-package rustic
  :ensure t)

(use-package cargo
  :ensure t
  :init
  (add-hook 'rustic-mode-hook 'cargo-minor-mode))

(use-package cider
  :ensure t)

(use-package sly
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (setq sly-lips-implementations
	'(sbcl ("/usr/bin/sbcl"))))

(use-package lsp-mode
  :commands lsp
  :config
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-ui-sideline-mode nil)
  (add-hook 'clojure-mode-hook 'lsp-mode)
  (add-hook 'clojurescript-mode-hook 'lsp-mode)
  (add-hook 'clojurec-mode-hook 'lsp-mode)
  ;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'c-mode-hook 'lsp-mode)
  (add-hook 'c++-mode-hook 'lsp-mode))

(use-package lsp-ui
  :ensure nil
  :commands lsp-ui-mode
  :custom
  ;; (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover f))

(use-package flymake-rust
  :ensure t)

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (setq company-idle-delay 0.5)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotation 1)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode))

;; Misc plugins/quality of life
(use-package elfeed
  :ensure t
  :config
  (setq-default elfeed-search-filter "@1-month-ago")
  (setq elfeed-feeds
	'("https://planet.emacslife.com/atom.xml"
	  "https://blog.rust-lang.org/feed.xml"
	  "https://undeadly.org/cgi?action=rss"
	  "https://feeds.npr.org/1001/rss.xml"
	  "https://xkcd.com/rss.xml"
	  "https://linux.com/feed"
	  "https://linuxfoundation.org/feed")))

(add-hook 'elfeed-show-mode-hook
	  (lambda ()
	    (set-face-attribute 'variable-pitch (selected-frame) :font (font-spec :family "Terminus" :size 14))
	    (setq fill-column 120)
	    (setq elfeed-show-entry-switch #'my-show-elfeed)))

(defun my-show-elfeed (buffer)
  (with-current-buffer buffer
    (setq buffer-read-only nil)
    (goto-char (point-min))
    (fill-individual-paragraphs (point) (point-max))
    (setq buffer-read-only t))
  (switch-to-buffer buffer))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (lisp-mode . rainbow-delimiters-mode)
  (common-lisp-mode . rainbow-delimiters-mode)
  (clojure-mode . rainbow-delimiters-mode)
  (emacs-lisp-mode . rainbow-delimiters-mode))

;; DO NOT EDIT BELOW

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-ui rainbow-delimiters elfeed eglot modus-themes evil-collection sly helm cider rustic async spacemacs spacemacs-theme zenburn-theme afternoon-theme projectile magit flycheck spaceline--helm-buffer-ids spaceline linum-relative flymake-rust lsp-mode evil-leader evil gruvbox-theme use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
