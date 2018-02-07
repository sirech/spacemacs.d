;; Inspired by _tf-fmt_ (https://github.com/dominikh/go-mode.el/blob/master/go-mode.el)
(defun tf-fmt-before-save ()
  (interactive)
  (when (eq major-mode 'terraform-mode) (tf-fmt)))

(defun tf-fmt ()
  "Format the current buffer according to the formatting tool.
The tool used can be set via ‘tf-fmt-command` (default: terraform fmt)"
  (interactive)
  (let ((tmpfile (make-temp-file "tf-fmt" nil ".tf"))
        (patchbuf (get-buffer-create "*tf-fmt patch*"))
        (errbuf (if tf-fmt-show-errors (get-buffer-create "*tf-fmt Errors*")))
        (coding-system-for-read 'utf-8)
        (coding-system-for-write 'utf-8)
        our-tf-fmt-args)

    (unwind-protect
        (save-restriction
          (widen)
          (if errbuf
              (with-current-buffer errbuf
                (setq buffer-read-only nil)
                (erase-buffer)))
          (with-current-buffer patchbuf
            (erase-buffer))

          (write-region nil nil tmpfile)

          (setq our-tf-fmt-args (append (list "fmt")
                                        our-tf-fmt-args
                                        tf-fmt-args
                                        (list "-write=true" tmpfile)))
          (message "Calling terraform fmt: %s %s" tf-fmt-command our-tf-fmt-args)
          ;; We're using errbuf for the mixed stdout and stderr output. This
          ;; is not an issue because terraform ftm -write=true does not produce any stdout
          ;; output in case of success.
          (if (zerop (apply #'call-process tf-fmt-command nil errbuf nil our-tf-fmt-args))
              (progn
                (if (zerop (call-process-region (point-min) (point-max) "diff" nil patchbuf nil "-n" "-" tmpfile))
                    (message "Buffer is already formatted")
                  (go--apply-rcs-patch patchbuf)
                  (message "Applied formatting"))
                (if errbuf (tf-fmt--kill-error-buffer errbuf)))
            (message "Could not apply format")
            (if errbuf (tf-fmt--process-errors (buffer-file-name) tmpfile errbuf))))

      (kill-buffer patchbuf)
      (delete-file tmpfile))))

(defun tf-fmt--kill-error-buffer (errbuf)
  (let ((win (get-buffer-window errbuf)))
    (if win
        (quit-window t win)
      (kill-buffer errbuf))))

(defun tf-fmt--process-errors (filename tmpfile errbuf)
  (with-current-buffer errbuf
    (if (eq tf-fmt-show-errors 'echo)
        (progn
          (message "%s" (buffer-string))
          (tf-fmt--kill-error-buffer errbuf))
      ;; Convert the gofmt stderr to something understood by the compilation mode.
      (goto-char (point-min))
      (insert "terraform errors:\n")
      (let ((truefile tmpfile))
        (while (search-forward-regexp (concat "^\\(" (regexp-quote truefile) "\\):") nil t)
          (replace-match (file-name-nondirectory filename) t t nil 1)))
      (compilation-mode)
      (display-buffer errbuf))))

(defun go--apply-rcs-patch (patch-buffer)
  "Apply an RCS-formatted diff from PATCH-BUFFER to the current buffer."
  (let ((target-buffer (current-buffer))
        ;; Relative offset between buffer line numbers and line numbers
        ;; in patch.
        ;;
        ;; Line numbers in the patch are based on the source file, so
        ;; we have to keep an offset when making changes to the
        ;; buffer.
        ;;
        ;; Appending lines decrements the offset (possibly making it
        ;; negative), deleting lines increments it. This order
        ;; simplifies the forward-line invocations.
        (line-offset 0))
    (save-excursion
      (with-current-buffer patch-buffer
        (goto-char (point-min))
        (while (not (eobp))
          (unless (looking-at "^\\([ad]\\)\\([0-9]+\\) \\([0-9]+\\)")
            (error "Invalid rcs patch or internal error in go--apply-rcs-patch"))
          (forward-line)
          (let ((action (match-string 1))
                (from (string-to-number (match-string 2)))
                (len  (string-to-number (match-string 3))))
            (cond
             ((equal action "a")
              (let ((start (point)))
                (forward-line len)
                (let ((text (buffer-substring start (point))))
                  (with-current-buffer target-buffer
                    (cl-decf line-offset len)
                    (goto-char (point-min))
                    (forward-line (- from len line-offset))
                    (insert text)))))
             ((equal action "d")
              (with-current-buffer target-buffer
                (go--goto-line (- from line-offset))
                (cl-incf line-offset len)
                (go--delete-whole-line len)))
             (t
              (error "Invalid rcs patch or internal error in go--apply-rcs-patch")))))))))

(defun go--goto-line (line)
  (goto-char (point-min))
  (forward-line (1- line)))

(defun go--delete-whole-line (&optional arg)
  "Delete the current line without putting it in the `kill-ring'.
Derived from function `kill-whole-line'.  ARG is defined as for that
function."
  (setq arg (or arg 1))
  (if (and (> arg 0)
           (eobp)
           (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0)
           (bobp)
           (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (cond ((zerop arg)
         (delete-region (progn (forward-visible-line 0) (point))
                        (progn (end-of-visible-line) (point))))
        ((< arg 0)
         (delete-region (progn (end-of-visible-line) (point))
                        (progn (forward-visible-line (1+ arg))
                               (unless (bobp)
                                 (backward-char))
                               (point))))
        (t
         (delete-region (progn (forward-visible-line 0) (point))
                        (progn (forward-visible-line arg) (point))))))
