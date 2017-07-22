(defconst aj-javascript-packages
  '(
    add-node-modules-path
    company
    company-flow
    ;; company-tern
    eslintd-fix
    evil-matchit
    flycheck
    ;; prettier-js
    rjsx-mode
    smartparens
    ;; tern
    ))

(defun aj-javascript/init-eslintd-fix ()
  (use-package eslintd-fix
    :defer t
    :commands eslintd-fix-mode
    :init
    (progn
      (add-hook 'rjsx-mode-hook #'eslintd-fix-mode t))))

(defun aj-javascript/init-rjsx-mode ()
  (use-package rjsx-mode
    :defer t
    :init
    (progn
      (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

      (setq
       js2-mode-show-strict-warnings nil
       js2-mode-show-parse-errors nil
       js-indent-level 2
       js2-basic-offset 2
       js-switch-indent-offset 2
       js2-strict-trailing-comma-warning nil
       js2-strict-missing-semi-warning nil)

      (advice-add #'js-jsx-indent-line
                  :after
                  #'aj-javascript/js-jsx-indent-line-align-closing-bracket)
      (add-hook 'rjsx-mode-hook #'aj-javascript/eslintd-set-flycheck-executable t))
    :config
    (modify-syntax-entry ?_ "w" js2-mode-syntax-table)))

;; (defun aj-javascript/init-prettier-js ()
;;   (use-package prettier-js
;;     :defer t
;;     :init
;;     (progn
;;       (add-hook 'rjsx-mode-hook 'prettier-js-mode)
;;       (setq prettier-js-args '(
;;                                "--trailing-comma" "es5"
;;                                "--bracket-spacing" "false"
;;                                "--no-semi"
;;                                "--single-quote")))))

(defun aj-javascript/post-init-add-node-modules-path ()
  (with-eval-after-load 'rjsx-mode
    (add-hook 'rjsx-mode-hook #'add-node-modules-path)))

(defun aj-javascript/post-init-company ()
  (spacemacs|add-company-hook rjsx-mode))

(defun aj-javascript/post-init-company-flow ()
  (spacemacs|add-company-backends
    :backends
    '((company-flow :with company-dabbrev-code)
      company-files)))

;; (defun aj-javascript/post-init-company-tern ()
;;   (push 'company-tern company-backends-rjsx-mode))

(defun aj-javascript/post-init-evil-matchit ()
  (with-eval-after-load 'evil-matchit
    (plist-put evilmi-plugins 'rjsx-mode
               '((evilmi-simple-get-tag evilmi-simple-jump)
                 (evilmi-javascript-get-tag evilmi-javascript-jump)
                 (evilmi-html-get-tag evilmi-html-jump)))))

(defun aj-javascript/post-init-flycheck ()
  (with-eval-after-load 'flycheck
    (push 'javascript-jshint flycheck-disabled-checkers)
    (push 'json-jsonlint flycheck-disabled-checkers)
    (flycheck-add-mode 'javascript-eslint 'rjsx-mode))
  (add-hook 'rjsx-mode-hook #'spacemacs//react-use-eslint-from-node-modules)
  (spacemacs/add-flycheck-hook 'rjsx-mode))

(defun aj-javascript/post-init-smartparens ()
  (if dotspacemacs-smartparens-strict-mode
      (add-hook 'rjsx-mode-hook #'smartparens-strict-mode)
    (add-hook 'rjsx-mode-hook #'smartparens-mode)))

;; (defun aj-javascript/post-init-tern ()
;;   (add-hook 'rjsx-mode-hook 'tern-mode)
;;   (spacemacs//set-tern-key-bindings 'rjsx-mode))
