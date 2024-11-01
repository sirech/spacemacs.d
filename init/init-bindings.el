(define-key evil-insert-state-map (kbd "C-d") 'delete-char)

;; Not exactly sure which one of this does actually the trick, helm seems to overwrite this
(define-key evil-normal-state-map (kbd "C-<tab>") 'spacemacs/alternate-buffer)
(define-key evil-motion-state-map (kbd "<C-tab>") 'spacemacs/alternate-buffer)
(map! (:after evil
              :m (kbd "<C-tab>") 'spacemacs/alternate-buffer))
(map! (:after helm
              :m (kbd "<C-tab>") 'spacemacs/alternate-buffer))
(with-eval-after-load 'helm-mode
  '(progn
     (define-key evil-normal-state-map (kbd "C-<tab>") 'spacemacs/alternate-buffer)
     (define-key evil-motion-state-map (kbd "<C-tab>") 'spacemacs/alternate-buffer)
     ))

(provide 'init-bindings)
