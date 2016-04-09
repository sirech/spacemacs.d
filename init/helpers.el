(defun unset-local-key (package key &optional given-suffix)
  "Unset a key in the local keymap mode for a package. Additionally,
the default suffix for the mode map variable may be overwritten.

This function works whether the package was loaded already or
not.
"
  (let* ((suffix (or given-suffix "-mode-map"))
         (map (intern (concat
                       (symbol-name package)
                       suffix))))
    (if (featurep package)
        (progn
          (message "Unsetting key %s for %s" key package)
          (define-key (eval map) key nil))
      (eval-after-load package
        '(progn
           (message "Unsetting key %s for %s" key package)
           (define-key (eval map) key nil))))))

(defun add-to-list-multiple (list to-add)
  "Adds multiple items to list.
Allows for adding a sequence of items to the same list, rather
than having to call `add-to-list' multiple times."
  (interactive)
  (dolist (item to-add)
    (add-to-list list item)))

(provide 'helpers)
