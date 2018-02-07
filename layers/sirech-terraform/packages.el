;;; packages.el --- sirech-terraform layer packages file for Spacemacs.
(setq sirech-terraform-packages '(terraform-mode))

(defun sirech-terraform/init-terraform-mode ()
  (use-package terraform-mode
    :defer t
    :init
    (add-hook 'before-save-hook 'tf-fmt-before-save)))
