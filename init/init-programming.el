;; Web Mode

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

;; CSS
(eval-after-load 'css-mode
  '(progn
     (setq css-indent-offset 2)

     (setq flycheck-stylelintrc ".stylelintrc")
     (spacemacs/add-flycheck-hook 'css-mode)

     (defun prelude-css-mode-defaults ()
       (rainbow-mode +1))

     (setq prelude-css-mode-hook 'prelude-css-mode-defaults)

     (add-hook 'css-mode-hook 'add-node-modules-path)
     (add-hook 'css-mode-hook (lambda ()
                                (run-hooks 'prelude-css-mode-hook)))))

;; JS

(setq-default js2-basic-offset 2)
(setq js2-bounce-indent t)
(setq js2-cleanup-whitespace t)
(setq js2-highlight-level 3)
(setq js2-indent-on-enter-key t)

;; (with-eval-after-load 'flycheck
;;   (add-to-list 'auto-mode-alist '("client.*/.*\\.js\\'" . react-mode))
;;   )

;; Lua
(setq lua-indent-level 4)

;; Docker
(eval-after-load 'dockerfile-mode
  '(progn
     (when (executable-find "hadolint")
       (spacemacs/add-flycheck-hook 'dockerfile-mode))))

;; Terraform
(eval-after-load 'terraform-mode
  '(progn
     (add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)))

(provide 'init-programming)
