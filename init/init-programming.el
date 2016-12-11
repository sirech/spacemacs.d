;; Web Mode

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

;; CSS
(eval-after-load 'css-mode
  '(progn
     (setq css-indent-offset 2)

     (defun prelude-css-mode-defaults ()
       (rainbow-mode +1))

     (setq prelude-css-mode-hook 'prelude-css-mode-defaults)

     (add-hook 'css-mode-hook (lambda ()
                                (run-hooks 'prelude-css-mode-hook)))))

;; JS

(setq-default js2-basic-offset 2)
(setq js2-bounce-indent t)
(setq js2-cleanup-whitespace t)
(setq js2-highlight-level 3)
(setq js2-indent-on-enter-key t)

(with-eval-after-load 'flycheck
  (add-to-list 'auto-mode-alist '("client.*/actions.*\\.js\\'" . react-mode))
  (add-to-list 'auto-mode-alist '("client.*/reducers.*\\.js\\'" . react-mode))
  )

;; Lua
(setq lua-indent-level 4)

(provide 'init-programming)
