;;; config.el --- Go Layer config File for Spacemacs

;; variables
(defvar tf-fmt-command "terraform"
  "The command called to format")

(defvar tf-fmt-args nil
  "Additional arguments to pass to terraform fmt.")

(defvar tf-fmt-show-errors 'buffer
  "Where to display gofmt error output.
It can either be displayed in its own buffer, in the echo area, or not at all.
Please note that Emacs outputs to the echo area when writing
files and will overwrite gofmt's echo output if used from inside
a `before-save-hook'.")
