;;; avy-zap.el --- Zap to char using `avy'

;; Copyright (C) 2015  Junpeng Qiu

;; Author: Junpeng Qiu <qjpchmail@gmail.com>
;; URL: https://github.com/cute-jumper/avy-zap
;; Package-Version: 20150528.1444
;; Package-Requires: ((avy "0.2.0"))
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Zap to char using [avy].

;; This package is basically a fork of the functionality of [ace-jump-zap],
;; but using [avy] instead of [ace-jump-mode] as the jumping method.


;; [avy] https://github.com/abo-abo/avy

;; [ace-jump-zap] https://github.com/waymondo/ace-jump-zap

;; [ace-jump-mode] https://github.com/winterTTr/ace-jump-mode


;; 1 Setup
;; =======

;; ,----
;; | (add-to-list 'load-path "/path/to/avy-zap.el")
;; | (require 'avy-zap)
;; `----


;; 2 Usage
;; =======

;; Use `avy-zap-to-char' or `avy-zap-up-to-char' to perform `zap-to-char'
;; or `zap-up-to-char' in "avy-style"!

;; There are two *Do-What-I-Mean* versions: `avy-zap-to-char-dwim' and
;; `avy-zap-up-to-char-dwim'. `avy-zap-(up-)to-char-dwim' will perform
;; `zap-(up-)to-char' without prefix. If calling *dwim* versions with
;; prefix, then `avy-zap-(up-)to-char' will be used instead.

;; You can give key bindings to these commands. For example:
;; ,----
;; | (global-set-key (kbd "M-z") 'avy-zap-to-char-dwim)
;; | (global-set-key (kbd "M-Z") 'avy-zap-up-to-char-dwim)
;; `----


;; 3 Customization
;; ===============

;; - `avy-zap-forward-only': Setting this variable to non-nil means
;; zapping from the current point. The default value is `nil'.
;; - `avy-zap-function': Choose between `kill-region' or `delete-region'.
;; The default value is `kill-region'.


;; 4 Compared to ace-jump-zap
;; ==========================

;; This package provides the same functionality as `ace-jump-zap', but
;; lacks the `ajz/sort-by-closest' and `ajz/52-character-limit'
;; customization options. I don't use the sorting feature of
;; `ace-jump-zap', but if someone finds it useful, welcome to submit a
;; pull request!


;; 5 Related packages
;; ==================

;; - [ace-jump-zap]
;; - [avy]


;; [ace-jump-zap] https://github.com/waymondo/ace-jump-zap

;; [avy] https://github.com/abo-abo/avy

;;; Code:

(require 'avy)

(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.")

(defvar avy-zap-forward-only nil
  "Non-nil means zap forward from the current point.")

(defvar avy-zap-function 'kill-region
  "The function used for zapping to char.")

(defmacro avy-zap--flet-if (rebind-p binding &rest body)
  "If REBIND-P, temporarily override BINDING and execute BODY.
Otherwise, don't rebind."
  (declare (indent 2))
  (let* ((name (car binding))
         (old (cl-gensym (symbol-name name))))
    `(if ,rebind-p
         (let ((,old (symbol-function ',name)))
           (unwind-protect
               (progn
                 (fset ',name (lambda ,@(cdr binding)))
                 ,@body)
             (fset ',name ,old)))
       ,@body)))

(defsubst avy-zap--xor (a b)
  "Exclusive-or of A and B."
  (if a (not b) b))

(defun avy-zap--internal (&optional zap-up-to-char-p)
  "If ZAP-UP-TO-CHAR-P, perform `zap-up-to-char'."
  (let ((start (point))
        avy-all-windows)
    (avy-zap--flet-if
        avy-zap-forward-only
        (window-start (&optional window) (point))
      (funcall avy-zap-function start
               (progn
                 (call-interactively 'avy-goto-char)
                 (when (avy-zap--xor
                        (<= start (point))
                        zap-up-to-char-p)
                   (forward-char))
                 (point))))))

;;;###autoload
(defun avy-zap-to-char ()
  "Zap to char using `avy'."
  (interactive)
  (avy-zap--internal))

;;;###autoload
(defun avy-zap-to-char-dwim (&optional prefix)
  "With PREFIX, call `avy-zap-to-char'.
Without PREFIX, call `zap-to-char'."
  (interactive "P")
  (if prefix
      (avy-zap-to-char)
    (call-interactively 'zap-to-char)))

;;;###autoload
(defun avy-zap-up-to-char ()
  "Zap up to char using `avy'."
  (interactive)
  (avy-zap--internal t))

;;;###autoload
(defun avy-zap-up-to-char-dwim (&optional prefix)
  "With PREFIX, call `avy-zap-up-to-char'.
Without PREFIX, call `zap-up-to-char'."
  (interactive "P")
  (if prefix
      (avy-zap-up-to-char)
    (call-interactively 'zap-up-to-char)))

(provide 'avy-zap)
;;; avy-zap.el ends here
