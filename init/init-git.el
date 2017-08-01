(defun read-secrets ()
  (-map 'cdr
        (--map (s-match "export \\([^=]+\\)='\\(.+\\)'" it)
               (-remove 's-blank?
                        (--remove (s-starts-with? "#" it)
                                  (s-lines
                                   (f-read-text "~/.secrets")))))))
(defun import-vars-in-secrets ()
  (--map (let*
             ((var (nth 0 it))
              (val (nth 1 it)))
           (setenv var val))
         (read-secrets)))

(import-vars-in-secrets)

(provide 'init-git)
