;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Kovalev Pavel"
      user-mail-address "kovalev5690@gmail.com")

(setq doom-theme 'doom-nord)
(setq doom-font (font-spec :family "JetBrains Mono" :size 18)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 18)
      doom-big-font (font-spec :family "JetBrains Mono" :size 30)
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

(after! dap-mode
  (setq dap-go-debugger 'dlv))

(setq +latex-viewers '(zathura))
(map! :map LaTeX-mode-map
      :localleader
      :desc "View" "v" #'TeX-view
      :desc "Compile" "c" #'TeX-command-master
      :desc "Run all" "a" #'TeX-command-run-all)

;; (map! :map dap-mode-map
;;       :leader
;;       :prefix ("d" . "dap")
;;       ;; basics
;;       :desc "dap next"          "n" #'dap-next
;;       :desc "dap step in"       "i" #'dap-step-in
;;       :desc "dap step out"      "o" #'dap-step-out
;;       :desc "dap continue"      "c" #'dap-continue
;;       :desc "dap hydra"         "h" #'dap-hydra
;;       :desc "dap debug restart" "r" #'dap-debug-restart
;;       :desc "dap debug"         "s" #'dap-debug

;;       ;; debug
;;       :prefix ("dd" . "Debug")
;;       :desc "dap debug recent"  "r" #'dap-debug-recent
;;       :desc "dap debug last"    "l" #'dap-debug-last

;;       ;; eval
;;       :prefix ("de" . "Eval")
;;       :desc "eval"                "e" #'dap-eval
;;       :desc "eval region"         "r" #'dap-eval-region
;;       :desc "eval thing at point" "s" #'dap-eval-thing-at-point
;;       :desc "add expression"      "a" #'dap-ui-expressions-add
;;       :desc "remove expression"   "d" #'dap-ui-expressions-remove

;;       :prefix ("db" . "Breakpoint")
;;       :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
;;       :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
;;       :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
;;       :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

(after! ispell
  (setq ispell-dictionary "en_US,ru_RU")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,ru_RU"))
