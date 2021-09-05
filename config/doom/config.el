;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Kovalev Pavel"
      user-mail-address "kovalev5690@gmail.com")

(setq doom-theme 'doom-nord)
(setq doom-font (font-spec :family "JetBrains Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 14)
      doom-big-font (font-spec :family "Source Code Pro" :size 24)
      doom-unicode-font doom-font)
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))
(setq display-line-numbers-type t)

(setq org-directory "~/org/"
      projectile-project-search-path '("~/Projects/")
      all-the-icons-scale-factor 1.0)

(setq-default
 delete-by-moving-to-trash t
 window-combination-resize t
 x-stretch-cursor t)

(add-hook! go-mode 'subword-mode)

(setq +latex-viewers '(zathura))
(map! :map LaTeX-mode-map
      :localleader
      :desc "View" "v" #'TeX-view
      :desc "Compile" "c" #'TeX-command-master
      :desc "Run all" "a" #'TeX-command-run-all)

(after! ispell
  (setq ispell-dictionary "en_US,ru_RU")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,ru_RU"))
