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

(setq +latex-viewers '(zathura))
(setq org-directory "~/org/")

(after! ispell
  (setq ispell-dictionary "en_US,ru_RU")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,ru_RU"))
