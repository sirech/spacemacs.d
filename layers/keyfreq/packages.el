(setq keyfreq-packages '(keyfreq))

(defun keyfreq/init-keyfreq ()
  (use-package keyfreq
    :init
    (progn
      (keyfreq-mode 1)
      (keyfreq-autosave-mode 1))
    :config
    (progn
      (setq keyfreq-excluded-commands
            '(self-insert-command
              abort-recursive-edit
              forward-char
              backward-char
              evil-previous-line
              evil-next-line)))))
