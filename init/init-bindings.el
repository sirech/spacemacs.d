(define-key evil-insert-state-map (kbd "C-d") 'delete-char)

;; Not exactly sure which one of this does actually the trick, helm seems to overwrite this
(define-key evil-normal-state-map (kbd "C-<tab>") 'spacemacs/alternate-buffer)
(define-key evil-motion-state-map (kbd "<C-tab>") 'spacemacs/alternate-buffer)

(provide 'init-bindings)
