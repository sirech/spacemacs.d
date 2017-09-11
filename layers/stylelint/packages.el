(setq stylelint-packages '(
                           flycheck
                           css-mode
                           ))

(defun stylelint/post-init-flycheck ()
  (defun stylelint/use-stylelint-from-node-modules ()
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  "node_modules"))
           (global-stylelint (executable-find "stylelint"))
           (local-stylelint (expand-file-name "node_modules/.bin/stylelint"
                                           root))
           (stylelint (if (file-executable-p local-stylelint)
                       local-stylelint
                     global-stylelint)))
      (setq-local flycheck-stylelintrc (expand-file-name ".stylelintrc"))
      (setq-local flycheck-css-stylelint-executable stylelint)))

  (add-hook 'css-mode-hook #'stylelint/use-stylelint-from-node-modules)
  )
