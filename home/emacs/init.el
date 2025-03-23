;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       vertico

       :ui
       ;;doom
       doom-dashboard
       modeline
       nav-flash
       ophints
       (popup +defaults)
       window-select

       :editor
       evil

       :emacs
       undo

       :term
       eshell
       vterm

       :os
       (tty +osc)

       :lang
       emacs-lisp
       (nix +lsp)

       :config
       (default +bindings +smartparens))
