(use-package! stylix-theme)

;;;###package pos-tip
(setq pos-tip-internal-border-width 6
      pos-tip-border-width 1)

(use-package! solaire-mode
  :hook (doom-load-theme . solaire-global-mode)
  :hook (+popup-buffer-mode . turn-on-solaire-mode))
