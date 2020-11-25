;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Kovalev Pavel"
      user-mail-address "kovalev5690@gmail.com")

(setq doom-font (font-spec :family "mononoki" :size 15)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 15)
      doom-big-font (font-spec :family "Source Code Pro" :size 24)
      doom-unicode-font doom-font)
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(setq doom-theme 'doom-nord)

(setq org-directory "~/org/")

(setq display-line-numbers-type t)
