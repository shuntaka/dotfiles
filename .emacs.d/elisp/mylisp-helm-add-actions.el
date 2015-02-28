;;; -*- lexical-binding: t -*-
(require 'helm)
;;; それぞれの型に対する追加アクション
(defvar helm-user-actions-type-file nil)
(defvar helm-user-actions-type-buffer nil)
(defvar helm-user-actions-type-command nil)
(defvar helm-user-actions-type-function nil)
(defun helm-source-add-user-actions (source user-actions)
  (oset source :action
        (append (oref source :action)
                (cl-loop with orig = (oref source :action)
                         for (name . action) in user-actions
                         unless (member name orig)
                         append (helm-make-actions name action)))))
(defmethod helm-setup-user-source ((source helm-type-file))
  (helm-source-add-user-actions source (helm-user-actions-type 'file)))
(defmethod helm-setup-user-source ((source helm-type-buffer))
  (helm-source-add-user-actions source (helm-user-actions-type 'buffer)))
(defmethod helm-setup-user-source ((source helm-type-command))
  (helm-source-add-user-actions source (helm-user-actions-type 'command)))
(defmethod helm-setup-user-source ((source helm-type-function))
  (helm-source-add-user-actions source (helm-user-actions-type 'function)))
;;; 型に対して追加アクションを読まないバグを修正！
(dolist (type '(file buffer function command))
  (advice-add (intern (format "helm-actions-from-type-%s" type))
              :around `(lambda (&rest them)
                        (append (apply them)
                                (helm-user-actions-type ',type)))))
(defun helm-user-actions-type (type)
  (symbol-value (intern (format "helm-user-actions-type-%s" type))))

;;; キーバインドの設定
(defun helm-define-action-key (keymap key def)
  "アクションをキーバインドに設定"
  (define-key keymap key
    (lambda ()
      (interactive)
      (with-helm-alive-p
        (helm-quit-and-execute-action def)))))

(provide 'mylisp-helm-add-actions)
