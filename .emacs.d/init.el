;;##########################################################################
;; Index
;;##########################################################################
;; 1.
;; 2. Basic Settings
;; 3. Key Binding
;; 4. Manipulating Buffers and Files
;; 5. Moving Cursor
;; 6. Input Support
;; 7. Search and Replace
;; 8. Making Emacs Even More Convinient
;; 9. External Program
;; 11. View Mode
;; 13. For Programming
;; 14. Create Documents
;; 15. Helm & Anything
;; Color Theme and Font
;; Manipulating Frame and Window
;; For HTML and CSS
;; For SCSS
;; For JavaScript
;; For Perl
;; For Yaml
;; Miscellenious

;;===========================================================================
;; 1.
;;===========================================================================


;;----------------------------------------------
;; inherit path from PATH for GUI emacs
;;----------------------------------------------
;; ;; inheritting path from PATH for GUI emacs
;; ;; When opened from Desktep entry, PATH won't be set to shell's value.
;; ;;http://kotatu.org/blog/2012/03/02/emacs-path-settings/
;; (let ((path-str
;;            (replace-regexp-in-string
;;             "\n+$" "" (shell-command-to-string "echo $PATH"))))
;;      (setenv "PATH" path-str)
;;      (setq exec-path (nconc (split-string path-str ":") exec-path)))

;; for Node
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

;; for plsense, perly-sense
(setenv "PATH"
        (concat '"/Users/shun/perl5/perlbrew/perls/perl-5.10.1/bin:" (getenv "PATH")))

;; for scss-lint
(setq exec-path (append exec-path '("/usr/bin")))

;;=================================================================
;; 2. Basic Settings
;;=================================================================

;;----------------------------------------------
;; debug
;;http://stackoverflow.com/questions/5413959/wrong-type-argument-stringp-nil
;;----------------------------------------------
;; (setq debug-on-error t)

;;----------------------
;; append the  directory and its subdirectoreis to the load-path
;;----------------------
;; define add-to-load-path
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; add directories under "elisp", "elpa", "conf", "public_repos"
(add-to-load-path "auto-install" "elisp" "elpa" "conf" "public_repos")

;;----------------------------------------------
;; 2-2. auto-install.el
;;----------------------------------------------
;;How to use
;;M-x install-elisp URL
;;M-x install-elisp-from-emacswiki EmacsWikiのページ名
;;M-x install-elisp-from-gist gist-id
;;M-x autoinsall-batch

;; auto-installによってインストールされるEmacs Lispをロードパスに加える
;; デフォルトは ~/.emacs.d/auto-install/
(add-to-list 'load-path "~/.emacs.d/auto-install/")
(require 'auto-install)

;; set .emacs.d/elisp as the auto-install directory
;(setq auto-install-directory "~/.emacs.d/elisp/")

;; 起動時にEmacsWikiのページ名を補完候補に加える

;; install-elisp.el互換モードにする
(auto-install-compatibility-setup)

;; ediff関連のバッファを1つのフレームにまとめる
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;----------------------------------------------
;; 2-3. setting for ELPA (package.el)
;;----------------------------------------------
;; How to use
;; M-x list-packages
;;     or
;; M-x package-refresh-contents
;; M-x package-initialize "package name"

(package-initialize)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;----------------------------------------------
;; from Emacs Technique Bible Basic Setting
;;----------------------------------------------
;;; 履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; ファイル内のカーソル位置を記憶する
(setq-default save-place t)
(require 'saveplace)

;;; 対応する括弧を光らせる
(show-paren-mode t)

;;; シェルに合わせるため、C-hは後退に割り当てる
;;; ヘルプは<f1>
(global-set-key (kbd "C-h") 'delete-backward-char)

;;; モードラインに時刻を表示する
(display-time)

;;; 行番号・桁番号を表示する
(line-number-mode 1)
(column-number-mode 1)

;;; リージョンに色をつける
(transient-mark-mode 1)

;;; GCを減らして軽くする（デフォルトの10倍）
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;;; ログの記録行数を増やす
(setq message-log-max 10000)

;;; ミニバッファを再起的に呼び出す
(setq enable-recursive-minibuffers t)

;;; ダイアログボックスを使わないようにする
(setq use-dialog-box nil)
(defalias 'message-box 'message)

;;; 履歴をたくさん保存する
(setq history-length 1000)

;;; キーストロークをエコーエリアに早く表示する
(setq echo-keystrokes 0.1)

;;; 大きいファイルを開くときに警告を表示する 10MBから25MBへ
(setq large-file-warning-threshold (* 25 1024 1024))

;;; ミニバッファで入力を取り消しても履歴に残す
;;; 誤って取り消して入力が失われるのを防ぐため
(defadvice abort-recursive-edit (before minibuffer-save activate)
  (when (eq (selected-window) (active-minibuffer-window))
    (add-to-history minibuffer-history-variable (minibuffer-contents))))

;;; yesをyで応答するように
(defalias 'yes-or-no-p 'y-or-n-p)

;;; goto-line ショートカット
(global-set-key "\M-g" 'goto-line)


;;----------------------
;; Hilight the current line
;;----------------------
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;;----------------------------------------------
;; make highlight the current line light
;; http://rubikitch.com/2015/05/14/global-hl-line-mode-timer/
;;----------------------------------------------
(defun global-hl-line-timer-function ()
  (global-hl-line-unhighlight-all)
  (let ((global-hl-line-mode t))
    (global-hl-line-highlight)))
(setq global-hl-line-timer
      (run-with-idle-timer 0.03 t 'global-hl-line-timer-function))
;; (cancel-timer global-hl-line-timer)

;;----------------------
;; Emphasize Parenthesis
;;----------------------
(setq show-paren-delay 0)
(show-paren-mode t)
;; (setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")


;;----------------------------------------------
;; ターミナル以外はツーバーとスクロールバーを消す
;;----------------------------------------------
(when window-system
(tool-bar-mode 0)
(scroll-bar-mode 0))
(when (eq system-type 'darwin)
(tool-bar-mode -1)
(scroll-bar-mode -1))

;;----------------------
;; line-number on the left side
;;----------------------
(global-linum-mode t)

;;----------------------
;; show the file path for the currently opned file
;;----------------------
(setq frame-title-format "%f")

;;----------------------------------------------
;; tab width
;;----------------------------------------------
;; for html-mode
(add-hook 'html-mode-hook
          (lambda ()
            (setq-default tab-width 2)))

;; for javascript
(add-hook 'js2-mode-hook
          (lambda ()
            (setq-default tab-width 4)))


;; for Perl
(add-hook 'cperl-mode-hook
          (lambda ()
            (setq-default tab-width 4)))




;;----------------------------------------------
;; disable tab
;;----------------------------------------------
;; for elisp
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))


;; for yaml
(add-hook 'yaml-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))

;; for Perl
(add-hook 'cperl-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))

;;----------------------------------------------
;; generic mode
;;----------------------------------------------
(require 'generic-x)

;;----------------------------------------------
;; exec-path-from-shell
;; https://github.com/purcell/exec-path-from-shell
;; http://hitode909.hatenablog.com/entry/2013/08/04/194929
;;----------------------------------------------
(exec-path-from-shell-initialize)

;;=============================================
;; 3. Key Binding
;;=============================================

;;----------------------
;; use command key as meta key
;;----------------------
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;;----------------------
;; map C-h to backspace
;;----------------------
(keyboard-translate ?\C-h ?\C-?)

;;----------------------
;; use C-c l for toggle-truncate-lines
;;----------------------
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;;----------------------
;; use C-t for toggling the windows
;;----------------------
(define-key global-map (kbd "C-t") 'other-window)


;;----------------------
;;sequential.command.el
;;----------------------
(require 'sequential-command-config)
(sequential-command-setup-keys)

;;----------------------------------------------
;; 3.6 define-key
;;----------------------------------------------

(defun line-to-top-of-window () (interactive) (recenter 0))
(global-set-key (kbd "C-z") 'line-to-top-of-window)


;;----------------------
;; 3.9 key-chord.el
;;----------------------
(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)
(key-chord-define-global "jk" 'view-mode)
;; (key-chord-define emacs-lisp-mode-map "df" describe-function)


;;=============================================
;; 4. Manipulating Buffers and Files
;;=============================================

;;----------------------
;; 4.1 ffap.el open the specified file
;;----------------------
;; e.g. type C-x C-f with the cursor near a file name(e.g. init.el)
;; if it exists, that file is used as the file name to be opened
(ffap-bindings)

;;----------------------
;; 4.2 uniquify.el
;;----------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;;----------------------
;; 4.3 iswitchb.el
;;----------------------
;; (iswitchb-mode 1)
;; ;; バッファ読み取り関数を iswitchb にする
;; (setq read-buffer-function 'iswitchb-read-buffer)
;; ;; 部分文字列の代わりに正規表現を使う場合は t に設定する
;; (setq iswitchb-regexp nil)
;; ;; 新しいバッファを作成するときにいちいち聞いてこない
;; (setq iswitchb-prompt-newbuffer nil)

;;----------------------
;; 4.4 recentf.el
;;----------------------
;; 最近使ったファイルを開く
;; M-x recentf-open-files
;;   ref:「Emacsテクニックバイブル」 p.87
;; Author: rubikitch <rubikitch@ruby-lang.org>
;; Keywords: convenience, files
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/recentf-ext.el
(setq recentf-max-saved-items 3000)
(setq recentf-exclude '("/TAGS$" "/var/tmp/"))
(require 'recentf-ext)
(global-set-key [?\C-c ?r ?f] 'recentf-open-files)

;;----------------------
;; 4.5 bookmark.el
;;----------------------
;; ブックマークを変更したら即保存する
(setq bookmark-save-flag 1)
;; 超整理法
(progn
  (setq bookmark-sort-flag nil)
  (defun bookmark-arrange-latest-top ()
    (let ((latest ( bookmark-get-bookmark bookmark)))
      (setq bookmark-alist (cons latest (delq latest bookmark-aliset))))
    (bookmark-save))
  (add-hook 'bookmark-after-jump-hook 'bookmark-arrange-latest-top))

;;----------------------
;; 4.6 emacsclient
;;----------------------
;; (server-start)
(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))
;; 編集が終了したらEmacsをアイコン化する
;; (add-hook 'server-done-hook 'iconify-emacs-when-server-is-done)
;;  C-x C-cに割り当てる
(global-set-key (kbd "C-x C-c") 'server-edit)
;; M-x exitでEmacsを終了できるようにする
(defalias 'exit 'save-buffers-kill-emacs)

;;----------------------
;; 4.7 tempbuf.el
;;----------------------
(require 'tempbuf)
;; ファイルを開いたら自動的にtempbufを有効にする
;(add-hook 'find-file-hooks 'turn-on-tempbuf-mode)
;; diredバッファに対してtempbufを有効にする
;(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)

;;----------------------------------------------
;; 4.8 auto-save
;;----------------------------------------------
;; Disable auto save
;; http://blog.sanojimaru.com/post/20090254216/emacs
(setq auto-save-default nil)

;; auto-save-buffers-enhanced
;; http://rubikitch.com/2014/11/23/auto-save-buffers-enhanced/
;; (require 'auto-save-buffers-enhanced)

;; ;;; 特定のファイルのみ有効にする
;; (setq auto-save-buffers-enhanced-include-regexps '(".+")) ;全ファイル
;; ;; not-save-fileと.ignoreは除外する
;; (setq auto-save-buffers-enhanced-exclude-regexps '("^not-save-file" "\\.ignore$"))
;; ;;; Wroteのメッセージを抑制
;; (setq auto-save-buffers-enhanced-quiet-save-p t)
;; ;;; *scratch*も ~/.emacs.d/scratch に自動保存
;; (setq auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t)
;; (setq auto-save-buffers-enhanced-file-related-with-scratch-buffer
;;       (locate-user-emacs-file "scratch"))
;; (auto-save-buffers-enhanced t)

;; ;;; C-x a sでauto-save-buffers-enhancedの有効・無効をトグル
;; (global-set-key "\C-xas" 'auto-save-buffers-enhanced-toggle-activity)

;; ----------------------------------------------
;;
;; auto-save-buffers-enhanced frequency
;; https://github.com/kentaro/auto-save-buffers-enhanced/blob/master/auto-save-buffers-enhanced.el
;;----------------------------------------------
;; (defvar auto-save-buffers-enhanced-interval 3.0)
;;  "*Interval by the second.
;;For that time, `auto-save-buffers-enhanced-save-buffers' is in
;;idle")

;; ----------------------------------------------
;; don't auto-save remote files
;; http://qiita.com/tumf/items/40d4c35810017e0aeb29
;; ----------------------------------------------
;; (setq auto-save-buffers-enhanced-exclude-regexps '("^/ssh:" "/sudo:" "/multi:" "/scp:" "Remotes"))

;; ----------------------------------------------
;; Disable make backup file
;; ----------------------------------------------
(setq make-backup-files nil)

;;----------------------------------------------
;; backup locally
;; http://qiita.com/catatsuy/items/f9fad90fa1352a4d3161
;;----------------------------------------------
;; (setq make-backup-files t)
;; (setq backup-directory-alist
;;   (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
;;     backup-directory-alist))

;; ;; create auto-save file in ~/.emacs.d/backup
;; (setq auto-save-file-name-transforms
;;       `((".*" ,(expand-file-name "~/.emacs.d/backup/") t)))


;;----------------------------------------------
;; 4.13 Wdired.el
;;----------------------------------------------

;;----------------------------------------------
;; 4.14. tramp.el
;;----------------------------------------------
(require 'tramp)
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))

;;----------------------------------------------
;; not use zsh for tramp
;; http://qiita.com/catatsuy/items/f9fad90fa1352a4d3161
;;----------------------------------------------
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))

;----------------------------------------------
; 4.15. sudoedit.el
;----------------------------------------------
;; (server-start) ;  sudoeditで使う
;; (require 'sudo-ext)

;;----------------------------------------------
;; firestarter
;; http://rubikitch.com/2015/04/13/firestarter/
;;----------------------------------------------
;; (firestarter-mode)
;; ;;; 失敗時に結果をお知らせ
;; (setq firestarter-default-type 'failure)
;; ;;; コマンド実行後に実行したコマンドを知らせる
;; (defun firestarter-sentinel--show-command (&rest ignore)
;;   (run-at-time 1 nil 'message (format "firestarted: %s" (firestarter-format firestarter))))
;; (advice-add 'firestarter-sentinel :before 'firestarter-sentinel--show-command)

;; ;;; セキュリティと利便性を両立
;; ;; firestarterに任意の値を受け取れるようにする
;; (put 'firestarter 'safe-local-variable 'identity)
;; ;; firestarterが設定されているときはmessageでお知らせ
;; (defun find-file-hook--firestarter-notify ()
;;   (when (and (bound-and-true-p firestarter-mode) firestarter)
;;     (run-at-time 1 nil 'message "firestarter = %S" firestarter)))
;; (add-hook 'find-file-hook 'find-file-hook--firestarter-notify)
;; ;; ファイルに関連付けられていないバッファの保存時にfirestarterが設定されているときに警告
;; (defun warn-firestarter-before-saving-nonfile-buffer (&rest ignore)
;;   (let (it)
;;     (when (and (not buffer-file-name)
;;                (save-excursion
;;                  (save-restriction
;;                    (widen)
;;                    (goto-char (point-min))
;;                    (and (re-search-forward "firestarter *:" nil t)
;;                         (setq it (buffer-substring (point-at-bol) (point-at-eol))))))
;;                (not (yes-or-no-p (concat "Save buffer with firestarter\n" it))))
;;       (error "Quit saving because of dangerous firestarter setting."))))
;; (advice-add 'basic-save-buffer :before 'warn-firestarter-before-saving-nonfile-buffer)
;; (advice-add 'write-file :before 'warn-firestarter-before-saving-nonfile-buffer)


;;----------------------------------------------
;; auto-shell-command.el
;; http://rubikitch.com/2015/04/12/auto-shell-command-2/
;;----------------------------------------------
(require 'auto-shell-command)

;;; キーバインドの設定
;; 一時的に無効・有効にする
(global-set-key (kbd "C-c C-m") 'ascmd:toggle)
;; 実行結果をポップアップ表示する
(global-set-key (kbd "C-c C-,") 'ascmd:popup)
;; ファイルを指定してそれに対応するコマンドを実行させる
(global-set-key (kbd "C-c C-.") 'ascmd:exec)

;;; エラー時のポップアップを見やすくする
(push '("*Auto Shell Command*" :height 20 :noselect t) popwin:special-display-config)

;;; 結果の通知をGrowlで行う (optional)
;; (defun ascmd:notify (msg) (deferred:process-shell (format "growlnotify -m %s -t emacs" msg))))

;;; 各ファイルごとの設定
;;; $FILEがファイル名, $DIRがディレクトリ名に置換されます
;; e.g. junk/以下のRubyスクリプトは無条件で実行
;; (ascmd:add '("junk/.*\.rb" "ruby $FILE"))

(ascmd:add '("~/nexus/.*\.tt" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))
(ascmd:add '("~/nexus/.*\.ms" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))
(ascmd:add '("~/nexus/.*\.scss" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))
(ascmd:add '("~/nexus/.*\.css" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))
(ascmd:add '("~/nexus/.*\.js" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))

(ascmd:add '("~/nexus/.*\.pl" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))
(ascmd:add '("~/nexus/.*\.pm" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))

(ascmd:add '("~/nexus/.*\.rb" "find $DIR$FILE | perl -pe 's/(\\/Users\\/shun(.*?)$)/\\1 shunsuke\\.takamiya\\@pelican:\\/home\\/shunsuke\\.takamiya\\2/' | xargs rsync"))


;;=============================================
;; 5. Moving Cursor
;;=============================================
;;----------------------
;; poin-undo.el
;;----------------------
(require 'point-undo)
(define-key global-map (kbd "M-p") 'point-undo)
(define-key global-map (kbd "M-n") 'point-redo)

;;----------------------
;; bm.el
;;----------------------

;(setq-default bm-buffer-persistence t)
;(setq bm-restore-repository-on-load t)
;(require 'bm)
;(add-hook 'find-file-hooks 'bm-buffer-restore)
;(add-hook 'kill-buffer-hook 'bm-buffer-save)
;(add-hook 'after-save-hook 'bm-buffer-save)
;(add-hook 'after-revert-hook 'bm-buffer-restore)
;(add-hook 'vc-before-checkin-hook 'bm-buffer-save)
;(global-set-key (kbd "M-SPC") 'bm-toggle)
;(global-set-key (kbd "M-[") 'bm-previous)
;(global-set-key (kbd "M-]") 'bm-next)

;; bm.elの設定
;; (install-elisp "http://cvs.savannah.gnu.org/viewvc/*checkout*/bm/bm/bm.el")
;; (require 'bm)
;; ;; キーの設定
;; (global-set-key (kbd "M-SPC") 'bm-toggle)
;; (global-set-key (kbd "M-[") 'bm-previous)
;; (global-set-key (kbd "M-]") 'bm-next)
;; ;; マークのセーブ
;; (setq-default bm-buffer-persistence t)
;; ;; セーブファイル名の設定
;; (setq bm-repository-file "~/.emacs.d/bm-repository")
;; ;; 起動時に設定のロード
;; (setq bm-restore-repository-on-load t)
;; (add-hook 'after-init-hook 'bm-repository-load)
;; (add-hook 'find-file-hooks 'bm-buffer-restore)
;; (add-hook 'after-revert-hook 'bm-buffer-restore)
;; ;; 設定ファイルのセーブ
;; (add-hook 'kill-buffer-hook 'bm-buffer-save)
;; (add-hook 'auto-save-hook 'bm-buffer-save)
;; (add-hook 'after-save-hook 'bm-buffer-save)
;; (add-hook 'vc-before-checkin-hook 'bm-buffer-save)
;; ;; Saving the repository to file when on exit
;; ;; kill-buffer-hook is not called when emacs is killed, so we
;; ;; must save all bookmarks first
;; (add-hook 'kill-emacs-hook '(lambda nil
;;                               (bm-buffer-save-all)
;;                               (bm-repository-save)))

;; ;; デフォルトでは文字色を白に染めてくれたので背景色だけ弄るよう変更
;; (custom-set-faces
;;  '(bm-persistent-face ((t (:background "olive drab")))))

;; 背景オレンジ
;; (set-face-background 'bm-persistent-face "DarkOrange")

;背景ライトグリーン
;; (set-face-background 'bm-persistent-face "olive drab")

;; (setq bm-highlight-style 'bm-highlight-only-line)

;;----------------------------------------------
;; bm.el rubikiti setting
;;----------------------------------------------
;;; bm.el初期設定
(setq-default bm-buffer-persistence nil)
(setq bm-restore-repository-on-load t)
(require 'bm)
(add-hook 'find-file-hook 'bm-buffer-restore)
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'after-revert-hook 'bm-buffer-restore)
(add-hook 'vc-before-checkin-hook 'bm-buffer-save)
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))
(global-set-key (kbd "M-[") 'bm-previous)
(global-set-key (kbd "M-]") 'bm-next)

;;----------------------
;; goto-chg.el
;;----------------------
(require 'goto-chg)
(global-set-key (kbd "C-M-p") 'goto-last-change)
(global-set-key (kbd "C-M-n") 'goto-last-change-reverse)

;; (define-key global-map (kbd "<f8>") 'goto-last-change)
;; (define-key global-map (kbd "S-<f8>") 'goto-last-change-reverse)
;;(global-set-key [(control ?.)] 'goto-last-change)
;;(global-set-key [(control ?,)] 'goto-last-change-reverse)

;;----------------------
;; Vim H, M, L
;;----------------------
;;  - リスト6 ウィンドウ内のカーソル移動
(global-set-key (kbd "C-M-h") (lambda () (interactive) (move-to-window-line 0)))
(global-set-key (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))
(global-set-key (kbd "C-M-l") (lambda () (interactive) (move-to-window-line -1)))

;;=============================================
;; 6. Input Support
;;=============================================

;;----------------------
;; 6.2 redo+
;;----------------------
(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t) ; 過去のundoがredoされないようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)

;;----------------------------------------------
;; 6.5
;; http://rubikitch.com/tag/yasnippet/
;; http://vdeep.net/emacs-yasnippet
;;----------------------------------------------
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/mysnippets"
        "~/.emacs.d/elpa/yasnippet-20151108.1505/snippets"
        "~/.emacs.d/public_snippets"
      ))

;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t)
(global-set-key (kbd "C-c y") 'helm-yas-complete)
(push '("emacs.+/snippets/" . snippet-mode) auto-mode-alist)
(yas-global-mode 1)

;;----------------------------------------------
;; 6.9
;;----------------------------------------------
(require 'yasnippet-config)
;; (yas/setup "~/.emacs.d/plugins/yasnippet")
(global-set-key (kbd "C-x y") 'yas/register-oneshot-snippet)
(global-set-key (kbd "C-x C-y") 'yas/expand-oneshot-snippet)

;;----------------------------------------------
;; 6.10 hippie-expand
;;----------------------------------------------
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol-partially
        ))

;; (keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
;; (global-set-key (kbd "H-i") 'hippie-expand)

;;----------------------------------------------
;; 6.10' ido-vertical
;; http://rubikitch.com/2015/01/06/ido-vertical-mode/
;;----------------------------------------------
;; ;;; このときidoが使うwindowの高さは大きくした方がいい
;; (setq ido-max-window-height 0.75)
;; ;;; あいまいマッチは入れておこう
;; (setq ido-enable-flex-matching t)
;; (ido-mode 1)
;; (ido-vertical-mode 1)
;; ;;; [2015-07-07 Tue]new: C-n/C-pで選択
;; (setq ido-vertical-define-keys 'C-n-and-C-p-only)
;; ;;; 他の選択肢: ↑と↓でも選択できるようにする
;; ;; (setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
;; ;;; ←と→で履歴も辿れるようにする
;; ;;(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)

;;----------------------------------------------
;; 6.10' show the list of the cancidates for hippie-expand with ido
;; http://stackoverflow.com/questions/6515009/how-to-configure-emacs-to-have-it-complete-the-path-automatically-like-vim/6556788#6556788
;;----------------------------------------------
(defun my-hippie-expand-completions (&optional hippie-expand-function)
  "Return the full list of possible completions generated by `hippie-expand'.
The optional argument can be generated with `make-hippie-expand-function'."
  (require 'cl)
  (let ((this-command 'my-hippie-expand-completions)
        (last-command last-command)
        (buffer-modified (buffer-modified-p))
        (hippie-expand-function (or hippie-expand-function 'hippie-expand)))
    (flet ((ding)) ; avoid the (ding) when hippie-expand exhausts its options.
      (while (progn
               (funcall hippie-expand-function nil)
               (setq last-command 'my-hippie-expand-completions)
               (not (equal he-num -1)))))
    ;; Evaluating the completions modifies the buffer, however we will finish
    ;; up in the same state that we began.
    (set-buffer-modified-p buffer-modified)
    ;; Provide the options in the order in which they are normally generated.
    (delete he-search-string (reverse he-tried-table))))

(defmacro my-ido-hippie-expand-with (hippie-expand-function)
  "Generate an interactively-callable function that offers ido-based completion
using the specified hippie-expand function."
  `(call-interactively
    (lambda (&optional selection)
      (interactive
       (let ((options (my-hippie-expand-completions ,hippie-expand-function)))
         (if options
             (list (ido-completing-read "Completions: " options)))))
      (if selection
          (he-substitute-string selection t)
        (message "No expansion found")))))

(defun my-ido-hippie-expand ()
  "Offer ido-based completion for the word at point."
  (interactive)
  (my-ido-hippie-expand-with 'hippie-expand))

(global-set-key (kbd "C-c e") 'my-ido-hippie-expand)

;;----------------------------------------------
;; 6.12
;; http://rubikitch.com/2014/08/28/elmacro/
;;----------------------------------------------
(require 'elmacro)
(elmacro-mode)

;;----------------------------------------------
;; 6.14 company-mode
;; http://qiita.com/sune2/items/b73037f9e85962f5afb7
;; http://rubikitch.com/2014/10/14/company/
;;----------------------------------------------
(require 'company)
(global-company-mode) ; 全バッファで有効にする
(setq company-idle-delay nil) ; デフォルトは0.5
(setq company-minimum-prefix-length 2) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)

(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(global-set-key (kbd "H-i") 'company-complete)

;;----------------------------------------------
;; 6.14' include the hippie-expand candidate in company-mode
;; https://github.com/company-mode/company-mode/issues/328
;;----------------------------------------------
(defun my-try-expand-company (old)
    (unless company-candidates
      (company-auto-begin))
    (if (not old)
        (progn
          (he-init-string (he-lisp-symbol-beg) (point))
          (if (not (he-string-member he-search-string he-tried-table))
              (setq he-tried-table (cons he-search-string he-tried-table)))
          (setq he-expand-list
                (and (not (equal he-search-string ""))
                     company-candidates))))
    (while (and he-expand-list
                (he-string-member (car he-expand-list) he-tried-table))
      (setq he-expand-list (cdr he-expand-list)))
    (if (null he-expand-list)
        (progn
          (if old (he-reset-string))
          ())
      (progn
    (he-substitute-string (car he-expand-list))
    (setq he-expand-list (cdr he-expand-list))
    t)))


;;----------------------------------------------
;; undo-tree
;;----------------------------------------------
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;;----------------------------------------------
;; undohisto
;;----------------------------------------------
;; (when (require 'undohist nil t)
;;   (undohist-initialize))

;;----------------------------------------------
;; smart-newline
;;----------------------------------------------
;;http://rubikitch.com/2014/12/31/smart-newline/
(require 'smart-newline)
(global-set-key (kbd "C-m") 'smart-newline)
(add-hook 'ruby-mode-hook 'smart-newline-mode)
(add-hook 'emacs-lisp-mode-hook 'smart-newline-mode)
(add-hook 'org-mode-hook 'smart-newline-mode)

(defadvice smart-newline (around C-u activate)
  "C-uを押したら元のC-mの挙動をするようにした。
org-modeなどで活用。"
  (if (not current-prefix-arg)
      ad-do-it
    (let (current-prefix-arg)
      (let (smart-newline-mode)
        (call-interactively (key-binding (kbd "C-m")))))))

;;----------------------
;; auto-compelte
;;----------------------
;; (require 'auto-complete-config)
;; (global-auto-complete-mode 1)
;; (when (require 'auto-complete-config nil t)
;;  (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
;;  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
;;  (ac-config-default))
;; (require 'auto-complete-config)

;;----------------------
;; cua-mode
;;----------------------
;; cua-modeの設定
;; (cua-mode t)  ; cua-modeをオン
;; (setq cua-enable-cua-keys nil)  ; CUAキーバインドを無効化

;;----------------------
;; thing
;;----------------------
(add-to-list 'load-path "~/.emacs.d/public_repos/thingopt-el")
(require 'thingopt)
(define-thing-commands)
;; short cut
(global-set-key (kbd "C-$") 'mark-word*)
(global-set-key (kbd "C-\"") 'mark-string)
(global-set-key (kbd "C-(") 'mark-up-list)

;; カーソル位置の行を複製するコマンド
(defun my-duplicate-thing (n &optional beg end)
  (interactive "p\nr")
  (let ((pos (- (point-max) (point)))
        str)
    (if mark-active
        nil
      (setq beg (point-at-bol)
            end (point-at-eol)))
    (setq str (buffer-substring-no-properties beg end))
    (if (not (= (progn (goto-char end) (preceding-char)) ?\n))
        (setq str (concat "\n" str)))
    (dotimes (i n)
      (insert str))
    (goto-char (- (point-max) pos))))
(global-set-key (kbd "H-y") 'my-duplicate-thing)

;;----------------------------------------------
;; notify too long row
;; http://rubikitch.com/2014/08/11/column-enforce-mode/
;;----------------------------------------------
(require 'column-enforce-mode)
(defun cperl-mode-hook--column-enforce-mode ()
  (set (make-local-variable 'column-enforce-column) 80)
  (column-enforce-mode 1))
(add-hook 'cperl-mode-hook 'cperl-mode-hook--column-enforce-mode)

;;----------------------------------------------
;; cursor-in-brackets.el
;;----------------------------------------------
;;http://d.hatena.ne.jp/yascentur/20130526/1369550512
(when (require 'cursor-in-brackets nil t)
  (global-cursor-in-brackets-mode t))

;;----------------------------------------------
;; kill-line and delete indent
;;http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part16
;;----------------------------------------------
(defadvice kill-line (before kill-line-and-fixup activate)
  (when (and (not (bolp)) (eolp))
    (forward-char)
    (fixup-whitespace)
    (backward-char)))

;;----------------------------------------------
;; auto cleanup white space
;; http://qiita.com/itiut@github/items/4d74da2412a29ef59c3a
;;----------------------------------------------
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; 保存前に自動でクリーンアップ
(setq whitespace-action '(auto-cleanup))

(global-whitespace-mode 1)

(defvar my/bg-color "#232323")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)


;;=================================================================
;; 7. Search and Replace
;;=================================================================
;;----------------------------------------------
;; ace-jump-mode
;;http://rubikitch.com/2014/10/09/ace-jump-mode/
;;----------------------------------------------
;; ヒント文字に使う文字を指定する
(setq ace-jump-mode-move-keys
      (append "asdfghjkl;:]qwertyuiop@zxcvbnm,." nil))
;; ace-jump-word-modeのとき文字を尋ねないようにする
(setq ace-jump-word-mode-use-query-char nil)
(global-set-key (kbd "C-o") 'ace-jump-char-mode)
;; (global-set-key (kbd "C-;") 'ace-jump-word-mode)
(global-set-key (kbd "C-M-;") 'ace-jump-line-mode)

;;----------------------------------------------
;; avy
;; http://rubikitch.com/2015/05/20/avy/
;;----------------------------------------------
;; (global-set-key (kbd "C-o") 'avy-goto-char)
;; (global-set-key (kbd "C-M-;") 'avy-goto-line)

;;----------------------------------------------
;; visual-regexp-steroids
;; http://rubikitch.com/2015/04/20/visual-regexp-steroids/
;;----------------------------------------------
(require 'visual-regexp-steroids)
(setq vr/engine 'python)                ;python regexpならばこれ
;; (setq vr/engine 'pcre2el)               ;elispでPCREから変換
(global-set-key (kbd "M-%") 'vr/query-replace)
;; multiple-cursorsを使っているならこれで
(global-set-key (kbd "C-c m") 'vr/mc-mark)
;; 普段の正規表現isearchにも使いたいならこれを
(global-set-key (kbd "C-M-r") 'vr/isearch-backward)
(global-set-key (kbd "C-M-s") 'vr/isearch-forward)

;;----------------------------------------------
;; ag.el
;;http://rubikitch.com/2014/09/12/ag/
;;----------------------------------------------
(setq ag-highlight-search t)

;;------------------------------------------------------------------------------------------
;; wgrep-ag.el
;;http://kotatu.org/blog/2013/12/18/emacs-aag-wgrep-for-code-grep-search/
;;------------------------------------------------------------------------------------------
;; ag
;; ag(The Silver Searcher)コマンドを以下からインストール:
;;     http://github.com/ggreer/the_silver_searcher#installation
;; ag.elとwgrep-ag.elをlist-packageでMelpaなどからインストールしておく
(require 'ag)
(custom-set-variables
 '(ag-highlight-search t)  ; 検索結果の中の検索語をハイライトする
 '(ag-reuse-window 'nil)   ; 現在のウィンドウを検索結果表示に使う
 '(ag-reuse-buffers 'nil)) ; 現在のバッファを検索結果表示に使う
(require 'wgrep-ag)
(autoload 'wgrep-ag-setup "wgrep-ag")
(add-hook 'ag-mode-hook 'wgrep-ag-setup)
;; agの検索結果バッファで"r"で編集モードに。
;; C-x C-sで保存して終了、C-x C-kで保存せずに終了
(define-key ag-mode-map (kbd "r") 'wgrep-change-to-wgrep-mode)
;; キーバインドを適当につけておくと便利。"\C-xg"とか
;; (global-set-key [(super m)] 'ag)
(global-set-key (kbd "M-m") 'ag-regexp)
;; ag開いたらagのバッファに移動するには以下をつかう
(defun my/filter (condp lst)
  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))
(defun my/get-buffer-window-list-regexp (regexp)
  "Return list of windows whose buffer name matches regexp."
  (my/filter #'(lambda (window)
              (string-match regexp
               (buffer-name (window-buffer window))))
          (window-list)))
(global-set-key [(super m)]
                #'(lambda ()
                    (interactive)
                    (call-interactively 'ag)
                    (select-window ; select ag buffer
                     (car (my/get-buffer-window-list-regexp "^\\*ag ")))))

;;----------------------------------------------
;; old_ace-isearch
;;http://rubikitch.com/2014/10/08/ace-isearch/
;;https://github.com/tam17aki/ace-isearch
;;----------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/public_repos/ace-isearch")
;; (require 'ace-isearch)
;; (global-ace-isearch-mode 1)
;; (ace-isearch-input-idle-delay 0.1)

;;----------------------
;; old_Moccur
;;----------------------
;; (require 'color-moccur)
;; (setq moccur-split-word t)

;;----------------------------------------------
;; old_wgrep
;; http://rubikitch.com/2014/09/13/wgrep/
;;----------------------------------------------
;; ;; 1. M-x ag
;; ;; 2. eでwgrep-modeにする
;; ;; 3. *grep*バッファを編集する
;; ;; 4. C-c C-c (C-x C-s)でファイルに反映！

;; ;;; eでwgrepモードにする
;; (setf wgrep-enable-key "e")
;; ;;; wgrep終了時にバッファを保存
;; (setq wgrep-auto-save-buffer t)
;; ;;; read-only bufferにも変更を適用する
;; (setq wgrep-change-readonly-file t)

;;----------------------------------------------
;; old_foreign-regexp.el
;;----------------------------------------------
;; (require 'foreign-regexp)
;; (custom-set-variables
;;  '(foreign-regexp/regexp-type 'perl)    ; perl や javascript も指定可能
;;  '(reb-re-syntax 'foreign-regexp))

;;----------------------------------------------
;; old_visual-regexp
;;----------------------------------------------
;; (global-set-key (kbd "M-%") 'vr/query-replace)

;;=============================================
;; 8 Make Emacs More Convinient
;;=============================================
(require 'col-highlight)
;; (column-highlight-mode 1)
;; (toggle-highlight-column-when-idle 1)
;; (col-highlight-set-interval 6)

;;----------------------------------------------
;; 8.4 eww
;;----------------------------------------------
;; google
(setq eww-search-prefix "https://www.google.co.jp/search?q=")

;; color
(require 'eww)
;;; [2014-11-17 Mon]背景・文字色を無効化する
(defvar eww-disable-colorize t)
(defun shr-colorize-region--disable (orig start end fg &optional bg &rest _)
  (unless eww-disable-colorize
    (funcall orig start end fg)))
(advice-add 'shr-colorize-region :around 'shr-colorize-region--disable)
(advice-add 'eww-colorize-region :around 'shr-colorize-region--disable)
(defun eww-disable-color ()
  "ewwで文字色を反映させない"
  (interactive)
  (setq-local eww-disable-colorize t)
  (eww-reload))
(defun eww-enable-color ()
  "ewwで文字色を反映させる"
  (interactive)
  (setq-local eww-disable-colorize nil)
  (eww-reload))

;;----------------------------------------------
;; edit-server
;; http://qiita.com/umi_uyura/items/6551ca1955302c91f8de
;; http://blog.kechako.com/entry/2011/12/02/105752
;;----------------------------------------------
(when (locate-library "edit-server")
  (require 'edit-server)
  (defvar edit-server-new-frame nil)    ; 新しいフレームは開かない
  (edit-server-start))

;;=================================================================
;; 9. External Program
;;=================================================================

;;----------------------------------------------
;; Google日本語入力(Macの時)
;;----------------------------------------------
;;Google 日本語入力
;; (when (eq window-system 'ns)
;; (setq default-input-method "MacOSX")
;; (mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `title "あ"))

;; (when (eq window-system 'ns)
;; (set-fontset-font
;;  nil 'japanese-jisx0208
;; (font-spec :family "Hiragino Kaku Gothic ProN")))

;----------------------------------------------
;; 9-9. Multi Term
;;----------------------------------------------
(when (require 'multi-term nil t)
  (setq multi-term-program "/usr/local/bin/zsh"))

(require 'multi-term)
(add-hook 'term-mode-hook '(lambda ()
                           (setq show-trailing-whitespace nil)))
(global-set-key (kbd "C-c t")
               '(lambda () (interactive) (multi-term)))
(global-set-key (kbd "C-c n") 'multi-term-next)
(global-set-key (kbd "C-c p") 'multi-term-prev)
(setq multi-term-program shell-file-name
     ansi-term-color-vector [term
                             term-color-black
                             term-color-green
                             term-color-yellow
                             term-color-blue
                             term-color-magenta
                             term-color-cyan
                             term-color-white])

;;----------------------------------------------
;; Tmux
;;----------------------------------------------
(defun terminal-init-screen ()
      "Terminal initialization function for screen."
      ;; Use the xterm color initialization code.
      (load "term/xterm")
      (xterm-register-default-colors))

;;----------------------------------------------
;; emamux
;;----------------------------------------------
(require 'emamux)

(defun copy-to-tmux ()
  (interactive)
  (if (use-region-p)
	  (kill-ring-save (region-beginning)(region-end)))
  (let (
		(data (substring-no-properties (car kill-ring))))
	(emamux:set-buffer data 0))
  (shell-command "tmux save-buffer - | nc -q1 localhost 2224")
  )

(global-set-key (kbd "C-M-w") 'copy-to-tmux)

;;----------------------------------------------
;; magit
;;----------------------------------------------
(require 'magit)
(global-set-key (kbd "C-x v d") 'magit-status)
(global-set-key (kbd "C-x v L") 'magit-key-mode-popup-logging)
(global-set-key (kbd "C-x v z") 'magit-stash)
(define-key magit-mode-map "\M-l" "l-all")

;;----------------------------------------------
; emacs-dbi
;;----------------------------------------------
;; make sure RPC::EPC::Service, DBI, DBD::Pg is installed
;; enable the following when using local perl
;;(add-to-list 'exec-path "~/perl5/perlbrew/perls/perl-5.16.3/bin/")
(autoload 'edbi:open-db-viewer "edbi")
(require 'edbi)

;; working with e2wm
;; (autoload 'e2wm:dp-edbi "e2wm-edbi" nil t)
(add-to-list 'load-path "~/projects/dotfiles/.emacs.d/elpa/edbi-20140920.35")
(autoload 'e2wm:dp-edbi "e2wm-edbi" nil t)
(global-set-key (kbd "s-d") 'e2wm:dp-edbi)


;;----------------------------------------------
;; iterm2
;;----------------------------------------------
(defun event-apply-meta-control-modifier (ignore-prompt)
  "\\Add the Meta-Control modifier to the following event.
For example, type \\[event-apply-meta-control-modifier] % to enter Meta-Control-%."
  (vector (event-apply-modifier
           (event-apply-modifier (read-event) 'control 26 "C-")
           'meta 27 "M-")))
(define-key function-key-map (kbd "C-x @ M") 'event-apply-meta-control-modifier)


;;=============================================
;; 11. view-mode
;;=============================================
(require 'view)
;; less
(define-key view-mode-map (kbd "N") 'View-search-last-regexp-backward)
(define-key view-mode-map (kbd "?") 'View-search-regexp-backward)
(define-key view-mode-map (kbd "G") 'View-goto-line-last)
(define-key view-mode-map (kbd "b") 'View-scroll-page-backward)
(define-key view-mode-map (kbd "f") 'View-scroll-page-forward)

;; ;; vi
;; (define-key view-mode-map (kbd "h") 'backward-char)
;; (define-key view-mode-map (kbd "j") 'next-line)
;; (define-key view-mode-map (kbd "k") 'previous-line)
;; (define-key view-mode-map (kbd "l") 'forward-char)
;; (define-key view-mode-map (kbd "J") 'View-scroll-line-forward)
;; (define-key view-mode-map (kbd "K") 'View-scroll-line-backward)

;; vi-derived
(define-key view-mode-map (kbd "h") 'backward-char)
(define-key view-mode-map (kbd "j") 'next-line)
(define-key view-mode-map (kbd "i") 'previous-line)
(define-key view-mode-map (kbd "l") 'forward-char)
(define-key view-mode-map (kbd "I") 'View-scroll-line-forward)
(define-key view-mode-map (kbd "J") 'View-scroll-line-backward)

;; bm.el
(define-key view-mode-map (kbd "m") 'bm-toggle)
(define-key view-mode-map (kbd "[") 'bm-previous)
(define-key view-mode-map (kbd "]") 'bm-next)

(require 'viewer)
(setq viewer-modeline-color-unwritable "tomato")
(setq viewer-modeline-color-view "orange")
(viewer-change-modeline-color-setup)

 ;;=============================================
;; 13. For Programming
;;=============================================
;;----------------------------------------------
;; 13.1 open-junk-file.el
;;----------------------------------------------
(require 'open-junk-file)
(setq open-junk-file-format "~/junk/%Y-%m-%d-%H%M%s.")

;;----------------------------------------------
;; 13.2 summarye.el
;;----------------------------------------------
(require 'summarye)

;;----------------------------------------------
;; 13.8 hideshow.el
;;----------------------------------------------
(require 'hideshow)
(require 'fold-dwim)

;;----------------------------------------------
;; 13.10 which-func-mode
;;----------------------------------------------
;;http://valvallow.blogspot.co.uk/2011/02/which-func-mode.html
(defun toggle-which-func-mode ()
  (interactive)
  (which-func-mode)
  (if which-func-mode
      (progn
        (delete (assoc 'which-func-mode mode-line-format)
                mode-line-format)
        (setq-default header-line-format
                      '(which-func-mode ("" which-func-format))))
    (setq-default header-line-format nil)))

;;----------------------
;; ipa.el
;;----------------------
(require 'ipa)
(set-face-background 'highlight "red")

;;----------------------
;; M-x which-func-mode
;;----------------------

;;----------------------
;; ctags
;;----------------------
(require 'ctags nil t)
(setq tags-revert-without-query t)
(setq ctags-command "/usr/local/bin/ctags -e -R ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

;;----------------------------------------------
;; flymake
;;----------------------------------------------
;; ;;http://blog.kentarok.org/entry/20080810/1218369556
;; (require 'flymake)

;; ;; set-perl5lib
;; ;; 開いたスクリプトのパスに応じて、PERL5LIBにlibを追加してくれる
;; ;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
;; (add-to-list 'load-path "~/.emacs.d/public_repos/1333926")
;; ;; (require 'set-perl5lib)

;; ;; エラー、ウォーニング時のフェイス
;; (set-face-background 'flymake-errline "red4")
;; (set-face-foreground 'flymake-errline "black")
;; (set-face-background 'flymake-warnline "yellow")
;; (set-face-foreground 'flymake-warnline "black")

;; ;; エラーをミニバッファに表示
;; ;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
;; (defun flymake-display-err-minibuf ()
;;   "Displays the error/warning for the current line in the minibuffer"
;;   (interactive)
;;   (let** ((line-no             (flymake-current-line-no))
;;          (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
;;          (count               (length line-err-info-list)))
;;     (while (> count 0)
;;       (when line-err-info-list
;;         (let** ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
;;                (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
;;                (text (flymake-ler-text (nth (1- count) line-err-info-list)))
;;                (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
;;           (message "[%s] %s" line text)))
;;       (setq count (1- count)))))

;;=============================================
;; 14. Create Documents
;;=============================================
(add-hook 'org-mode-hook
		  (lambda ()
		  (setq-default indent-tabs-mode nil)))

;;----------------------
;; 14.2
;;----------------------
(require 'org)
(defun org-insert-upheading (arg)
  (interactive "P")
  (org-insert-heading arg)
  (cond ((org-on-heading-p) (org-do-promote))
         ((org-at-item-p) (org-indent-item -1 ))))
(defun org-insert-heading-dwim (arg)
  (interactive "p")
  (case arg
    (4  (org-insert-subheading nil))
    (16 (org-insert-upheading nil))
    (t  (org-insert-heading nil))))
(define-key org-mode-map (kbd "<C-return>") 'org-insert-heading-dwim)

;;----------------------------------------------
;; 14.4
;;----------------------------------------------
;; (require 'org)
;; (org-remember-insinuate)

;; (setq org-directory "~/Dropbox/Memo/")
;; (setq org-default-notes-file (expand-file-name "memo.org" org-directory))

;; (setq org-remember-templates
;;       '(("Note" ?n "** %?\n %i\n %t" nil "Inbox")
;;         ("Todo" ?t "** TODO %?\n %i\n %a\n %t" nil "Inbox")))

;;----------------------------------------------
;; 14.4 (org-capture)
;; http://kamuycikap.hatenablog.com/entry/2015/02/04/181043
;;----------------------------------------------
;; Org-captureをC-c rで呼び出す。
;; (define-key global-map "\C-cr" 'org-capture)
(key-chord-define-global "ji" 'org-capture)

;; Org-caputure
;; Org-mode version8.xから導入されたorg-rememberの高機能版
(when (require 'org-capture nil t)

  (setq org-capture-templates
        '(("m" "Memo" entry (file+datetree "~/Dropbox/Memo/memo.org" "MEMO")
           "* %^{Title} %^g\n%?\nAdded: %U")
          ("t" "Todo" entry (file+headline "~/Dropbox/Manage/ToDo/Office/office_ToDo_INBOX.org" "====ToDo====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("h" "Home Todo" entry (file+headline "~/Dropbox/Manage/ToDo/Home/home_ToDo_INBOX.org" "====ToDo====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("E" "Edogawa Todo" entry (file+headline "~/Dropbox/Manage/ToDo/Edo/edogawa_ToDo_INBOX.org" "====ToDo====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("c" "CSS" entry (file+headline "~/Dropbox/Note/CSS_Note/css_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("e" "Emacs" entry (file+headline "~/Dropbox/Note/Emacs_Note/emacs_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("g" "Git" entry (file+headline "~/Dropbox/Note/Git_Note/git_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("j" "JavaScript" entry (file+headline "~/Dropbox/Note/JavaScript_Note/javascript_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("l" "Linux" entry (file+headline "~/Dropbox/Note/Linux_Note/linux_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("n" "Node" entry (file+headline "~/Dropbox/Note/Node_Note/node_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("o" "Perl One-Liner" entry (file+headline "~/Dropbox/Note/Perl_One-Liner_Note/perl_one-liner_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("p" "Perl" entry (file+headline "~/Dropbox/Note/Perl_Note/perl_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("r" "Regex" entry (file+headline "~/Dropbox/Note/Regex_Note/regex_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ("q" "jQuery" entry (file+headline "~/Dropbox/Note/jQuery_Note/jquery_note.org" "====Investigate====")
           "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
          ))

  (setq org-agenda-custom-commands
        '(
          ("s" "SVF Lists" tags "SVF")           ; SVFタグを抽出
          ("p" "Projects Lists" tags "PROJECT")  ; PROJECTタグを抽出
          ("n" "Note Lists" tags "NOTE")         ; NOTEタグを抽出
          ("h" "Office and Home Lists"           ; @OFFICEタグでTODO
           ((agenda)
            (tags-todo "@OFFICE")
            (tags-todo "@HOME")))

          ("d" "Daily Action List"
           (
            (agenda "" ((org-agenda-ndays 1)
                        (org-agenda-sorting-strategy
                         (quote ((agenda time-up priority-down tag-up) )))
                        (org-deadline-warning-days 0)
                        )))))))

;; short cut for tag-view by elmacro
(defun tag-view ()
  "tag view"
  (interactive)
  (org-match-sparse-tree nil))

(global-set-key (kbd "C-c q") 'tag-view)


;; short cut for moving completed task in ToDo_INBOX.org by elmacro
(defun move-task-item-to-COMPLETED ()
  "move the task item to the end of COMPLETED section"
  (interactive)
  (org-seq-home)
  (kill-line nil)
  (forward-page 1)
  (newline)
  (yank nil)
  (point-undo)
  (org-delete-char 1))

(global-set-key (kbd "C-c k") 'move-task-item-to-COMPLETED)



;;----------------------------------------------
;; 14.6
;;----------------------------------------------
(require 'org)
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "PROJECT(p)" "SUBPROJECT(s)" "|" "DONE(x)" "CANCEL(c)")
      ;; '((sequence "TODO(t)" "WAITING(w)" "PROJECT(p)" "SUBPROJECT(s)" "|" "DONE(x)" "CANCEL(c)")
        (sequence "APPT(a)" "|" "DONE(x)" "CANCEL(c)")))

;;----------------------------------------------
;; 14.14
;; http://qiita.com/takaxp/items/0b717ad1d0488b74429d
;;----------------------------------------------
(setq org-agenda-files
      '("~/Dropbox/Manage/ToDo/Office/office_ToDo_INBOX.org"
        "~/Dropbox/Manage/Todo/Office/jimu_todo.org"
        "~/Dropbox/Manage/Todo/Office/kai開発移管_todo.org"
        "~/Dropbox/Manage/Todo/Office/kan環境構築_todo.org"
        "~/Dropbox/Manage/Todo/Office/VMP_troubleshooting_todo.org"
        "~/Dropbox/Manage/Todo/Office/SRP_KT_todo.org"
        "~/Dropbox/Manage/ToDo/Office/schedule2015.org"
        ))
(global-set-key (kbd "C-c a") 'org-agenda)


;;----------------------
;;; howm from Otake Tomoy's  emacs Jissen Nyumon, p148
;;----------------------
;;(setq howm-directory (concat user-emacs-directory "howm"))

;;(setq howm-menu-lang 'ja)

;;(setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")

;;(when (require 'howm-mode nil t)

;;  (define-key global-map (kbd "C-c , ,") 'howm-menu))

;;(defun howm-save-buffer-and-kill ()
;;  (interactive)
;;  (when (and (buffer-file-name)
;;	     (string-match "\\.howm" (buffer-file-name)))
;;    (save-buffer)
;;    (kill-buffer nil)))

;;(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)

;;----------------------------------------------
;; calender
;; http://d.hatena.ne.jp/kiwanami/20110107/1294404952
;;----------------------------------------------
(add-hook 'calendar-load-hook
          (lambda ()
            (require 'japanese-holidays)
            (setq calendar-holidays
                  (append japanese-holidays local-holidays other-holidays))))
(require 'calfw) ; 初回一度だけ
;; (cfw:open-calendar-buffer) ; カレンダー表示

;;----------------------------------------------
;; calfw-org view
;; http://d.hatena.ne.jp/kiwanami/20110723/1311434175
;;----------------------------------------------
;; require calfw-org to view the schedule in the calender
(require 'calfw-org)
(global-set-key (kbd "C-c c") 'cfw:open-org-calendar)

;;----------------------------------------------
;; calfw-org view
;; http://qiita.com/takaxp/items/0b717ad1d0488b74429d
;; currently commented out
;;----------------------------------------------
;; ;; define autoload-if-func
;; ;; http://d.hatena.ne.jp/tomoya/20090811/1250006208
;; (defun autoload-if-found (function file &optional docstring interactive type)
;;   "set autoload iff. FILE has found."
;;   (and (locate-library file)
;;        (autoload function file docstring interactive type)))
;; ;; 使い方
;; ;; 引数は autoload と全く同じです。-if-found を付けるだけ
;; (when (autoload-if-found 'bs-show "bs" "buffer selection" t)
;;   ;; autoload は成功した場合のみ non-nil を返すので、
;;   ;; when の条件部に置くことで、依存関係にある設定項目を自然に表現できます。
;;   (global-set-key [(control x) (control b)] 'bs-show)
;;   (setq bs-max-window-height 10))

;; ;; open the schedule org file
;; (defun show-org-buffer (file)
;;     "Show an org-file on the current buffer"
;;     (interactive)
;;     (if (get-buffer file)
;;         (let ((buffer (get-buffer file)))
;;           (switch-to-buffer buffer)
;;           (message "%s" file))
;;      (find-file (concat "~/Dropbox/Manage/ToDo/" file))))
;; (global-set-key (kbd "C-M-c") '(lambda () (interactive)
;;                                   (show-org-buffer "schedule2015.org")))

;; ;; add schedule to the schedule org file
;; (defvar org-capture-ical-file (concat org-directory "schedule2015.org"))
;;  ;; see org.pdf:p73
;;  (setq org-capture-templates
;;       `(("t" "TODO 項目を INBOX に貼り付ける" entry
;;          (file+headline nil "INBOX") "** TODO %?\n\t")
;;          ("c" "同期カレンダーにエントリー" entry
;;           (file+headline ,org-capture-ical-file "Schedule")
;;           "** TODO %?\n\t")))

;; ;; copy a task to the schedule org file
;; (setq org-refile-targets
;;        (quote (("org-ical.org" :level . 1)
;;                ("next.org" :level . 1)
;;                ("sleep.org" :level . 1))))


;; ;; display the schedule on the schedule org file
;; ;; (when (autoload-if-found 'cfw:open-org-calendar "calfw-org"
;; ;;                          "Rich calendar for org-mode" t)
;;   (eval-after-load "calfw-org"
;;     '(progn
;;        ;; calfw-org で表示する org バッファを指定する
;;        (setq cfw:org-icalendars '("~/Dropbox/Manage/Schedule/schedule2015.org"))
;;        ;; org で使う表にフェイスを統一
;;        (setq cfw:fchar-junction ?+
;;                cfw:fchar-vertical-line ?|
;;                cfw:fchar-horizontal-line ?-
;;                cfw:fchar-left-junction ?|
;;                cfw:fchar-right-junction ?|
;;                cfw:fchar-top-junction ?+
;;                cfw:fchar-top-left-corner ?|
;;                cfw:fchar-top-right-corner ?| )))


;;===================================================================
;; 15. Helm & Anything
;;===================================================================
;;----------------------------------------------
;; Helm setting avoiding helm-file-name
;; http://rubikitch.com/2014/08/11/helm-avoid-find-files/
;;----------------------------------------------
(require 'helm)
(require 'helm-mode)
(defadvice helm-mode (around avoid-read-file-name activate)
  (let ((read-file-name-function read-file-name-function)
        (completing-read-function completing-read-function))
    ad-do-it))
(setq completing-read-function 'my-helm-completing-read-default)
(defun my-helm-completing-read-default (&rest _)
  (apply (cond ;; [2014-08-11 Mon]helm版のread-file-nameは重いからいらない
          ((eq (nth 1 _) 'read-file-name-internal)
           'completing-read-default)
          (t
           'helm--completing-read-default))
         _))

;;----------------------------------------------
;; fine-file時にhelm-completeに入るのを無効化
;; http://fukuyama.co/nonexpansion
;;----------------------------------------------
(custom-set-variables '(helm-ff-auto-update-initial-value nil))

;;----------------------------------------------
;; Helm Keybinding
;;----------------------------------------------
(global-set-key (kbd "C-;") 'helm-for-files)
(global-set-key(kbd "C-x b") 'helm-mini)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-c i")   'helm-imenu)
;; (define-key global-map (kbd "C-x b")   'helm-buffers-list)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(global-set-key (kbd "C-c s") 'helm-ag)
;; (global-set-key (kbd "!C-c y") 'helm-show-kill-ring)e

;; auto complete with TAB for find-file etc.
;; (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;; auto complete with TAB for helm-find-files etc.
;; (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

; disable helm for kill-buffer
;; (add-to-list 'helm-completing-read-handlers-alist '(kill-buffer . nil))

;;----------------------------------------------
;; Helm C-e C-j
;;----------------------------------------------
(require 'helm)
(defun helm-select-2nd-action ()
  "Select the 2nd action for the currently selected candidate."
  (interactive)
  (helm-select-nth-action 1))

(defun helm-select-3rd-action ()
  "Select the 3rd action for the currently selected candidate."
  (interactive)
  (helm-select-nth-action 2))

(defun helm-select-4th-action ()
  "Select the 4th action for the currently selected candidate."
  (interactive)
  (helm-select-nth-action 3))

(defun helm-select-2nd-action-or-end-of-line ()
  "Select the 2nd action for the currently selected candidate.
This happen when point is at the end of minibuffer.
Otherwise goto the end of minibuffer."
  (interactive)
  (if (eolp)
      (helm-select-nth-action 1)
    (end-of-line)))

(define-key helm-map (kbd "C-e")        'helm-select-2nd-action-or-end-of-line)
(define-key helm-map (kbd "C-j")        'helm-select-3rd-action)

;;----------------------------------------------
;; helm-swoop
;;
;; https://github.com/ShingoFukuyama/helm-swoop
;;----------------------------------------------
(add-to-list 'load-path "~/.emacs.d/public_repos/helm-swoop")
(require 'helm-swoop)
;; disable pre-input
(setq helm-swoop-pre-input-function
      (lambda () ""))
(global-set-key (kbd "C-s") 'helm-swoop)
;;; isearchからの連携を考えるとC-r/C-sにも割り当て推奨
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

;;----------------------------------------------
;; helm-swoop launch
;; http://rubikitch.com/2015/03/23/helm-swoop-update/
;;----------------------------------------------
;; (defun isearch-forward-or-helm-swoop (use-helm-swoop)
;;   (interactive "p")
;;   (let (current-prefix-arg
;;         (helm-swoop-pre-input-function 'ignore))
;;     (call-interactively
;;      (case use-helm-swoop
;;        (1 'isearch-forward)
;;        (4 'helm-swoop)
;;        (16 'helm-swoop-nomigemo)))))
;; (global-set-key (kbd "C-s") 'isearch-forward-or-helm-swoop)

;;----------------------------------------------
;; isearch-dabbrev
;;----------------------------------------------
(define-key isearch-mode-map (kbd "<tab>") 'isearch-dabbrev-expand)

;;----------------------------------------------
;; imenu-anyware
;;----------------------------------------------
;;http://rubikitch.com/category/helm/
(require 'imenu)
(setq ido-enable-flex-matching t)       ;あいまいマッチ
(global-set-key (kbd "C-.") 'ido-imenu-anywhere)
(global-set-key (kbd "C-M-.") 'helm-imenu-anywhere)

;;----------------------------------------------
;; enhanced imenu
;; http://rubikitch.com/tag/package:helm-swoop/
;;----------------------------------------------


;;----------------------------------------------
;; helm-next error
;;----------------------------------------------
;;http://rubikitch.com/category/helm/
;;;; replacement of `next-error' and `previous-error'

;; (require 'helm-anything nil t)
;; (require 'helm)

;;; resumable helm/anything buffers
(defvar helm-resume-goto-buffer-regexp
  (rx (or (regexp "Helm Swoop") "helm imenu" (regexp "helm.+grep") "helm-ag"
          "occur"
          "*anything grep" "anything current buffer")))
(defvar helm-resume-goto-function nil)
(defun helm-initialize--resume-goto (resume &rest _)
  (when (and (not (eq resume 'noresume))
             (ignore-errors
               (string-match helm-resume-goto-buffer-regexp helm-last-buffer)))
    (setq helm-resume-goto-function
          (list 'helm-resume helm-last-buffer))))
(advice-add 'helm-initialize :after 'helm-initialize--resume-goto)
(defun anything-initialize--resume-goto (resume &rest _)
  (when (and (not (eq resume 'noresume))
             (ignore-errors
               (string-match helm-resume-goto-buffer-regexp anything-last-buffer)))
    (setq helm-resume-goto-function
          (list 'anything-resume anything-last-buffer))))
(advice-add 'anything-initialize :after 'anything-initialize--resume-goto)

;;; next-error/previous-error
(defun compilation-start--resume-goto (&rest _)
  (setq helm-resume-goto-function 'next-error))
(advice-add 'compilation-start :after 'compilation-start--resume-goto)
(advice-add 'occur-mode :after 'compilation-start--resume-goto)
(advice-add 'occur-mode-goto-occurrence :after 'compilation-start--resume-goto)
(advice-add 'compile-goto-error :after 'compilation-start--resume-goto)


(defun helm-resume-and- (key)
  (unless (eq helm-resume-goto-function 'next-error)
    (if (fboundp 'helm-anything-resume)
        (setq helm-anything-resume-function helm-resume-goto-function)
      (setq helm-last-buffer (cadr helm-resume-goto-function)))
    (execute-kbd-macro
     (kbd (format "%s %s RET"
                  (key-description (car (where-is-internal
                                         (if (fboundp 'helm-anything-resume)
                                             'helm-anything-resume
                                           'helm-resume))))
                  key)))
    (message "Resuming %s" (cadr helm-resume-goto-function))
    t))
(defun helm-resume-and-previous ()
  "Relacement of `previous-error'"
  (interactive)
  (or (helm-resume-and- "C-p")
      (call-interactively 'previous-error)))
(defun helm-resume-and-next ()
  "Relacement of `next-error'"
  (interactive)
  (or (helm-resume-and- "C-n")
      (call-interactively 'next-error)))

;;; Replace: next-error / previous-error
(require 'helm-config)
(ignore-errors (helm-anything-set-keys))
(global-set-key (kbd "M-N") 'helm-resume-and-next)
(global-set-key (kbd "M-P") 'helm-resume-and-previous)

;;----------------------------------------------
;; helm-bm.el設定
;;----------------------------------------------
(require 'helm-bm)
;; migemoくらいつけようね
(push '(migemo) helm-source-bm)
;; annotationはあまり使わないので仕切り線で表示件数減るの嫌
(setq helm-source-bm (delete '(multiline) helm-source-bm))

(defun bm-toggle-or-helm ()
  "2回連続で起動したらhelm-bmを実行させる"
  (interactive)
  (bm-toggle)
  (when (eq last-command 'bm-toggle-or-helm)
    (helm-bm)))
(global-set-key (kbd "M-SPC") 'bm-toggle-or-helm)

;;; これがないとemacs -Qでエラーになる。おそらくバグ。
(require 'compile)

;背景ライトグリーン
(set-face-background 'bm-persistent-face "olive drab")

;;----------------------------------------------
;;helm-etags-plus
;;----------------------------------------------
(add-to-list 'load-path "~/.emacs.d/public_repos/helm-etags-plus")
(require 'helm-etags+)
(define-key global-map (kbd "M-.") 'helm-etags+-select)
(define-key global-map (kbd "M-,") 'helm-etags+-history-go-back)
(define-key global-map (kbd "C-.") 'helm-etags+-history-go-forward)
(define-key global-map (kbd "C-,") 'helm-etags+-history-go-back)

;; ;;----------------------------------------------
;; ;;helm-ag
;; ;;----------------------------------------------
;; (require 'helm-config)
;; (require 'helm-files)
;; (require 'helm-ag)

;; (global-set-key (kbd "M-g .") 'helm-ag)
;; (global-set-key (kbd "M-g ,") 'helm-ag-pop-stack)
;; (global-set-key (kbd "C-M-s") 'helm-ag-this-file)

;;----------------------------------------------
;;helm-ag-r
;;----------------------------------------------
;;http://sleepboy-zzz.blogspot.co.uk/2013/10/emacsaghelmhelm-ag-r_4267.html
(require 'helm-ag-r)
(setq
 helm-ag-r-google-contacts-user "your gmail address"
 helm-ag-r-google-contacts-lang "ja_JP.UTF-8"
 helm-ag-r-option-list '("-S -U --hidden"
                         "-S -U -g")
 ;; 不安定な場合以下の項目を調整すれば
 ;; よくなるかもしれません
 helm-ag-r-requires-pattern 3    ; 文字数以上入力してから検索
 helm-ag-r-input-idle-delay 0.5  ; 検索をdelay後からおこなう
 helm-ag-r-use-no-highlight t    ; ハイライト無効化
 helm-ag-r-candidate-limit 1000) ; 候補の上限を設定

;;----------------------------------------------
;; helm-c-do-shell-command
;;----------------------------------------------
(require 'mylisp-helm-add-actions)
(require 'dired-aux)

(defun helm-c-do-shell-command (ignore)
  (let ((files (mapcar 'expand-file-name (helm-marked-candidates)))
        (helm--reading-passwd-or-string t))
    (dired-do-shell-command
     (dired-read-shell-command
      (format "! on %s: "
              (dired-mark-prompt (length files) files))
      nil files)
     nil files)))

(setq helm-user-actions-type-file
      '(("Execute Shell Command" . helm-c-do-shell-command)))
(require 'helm-files)
(helm-define-action-key helm-generic-files-map (kbd "!") 'helm-c-do-shell-command)


;;=================================================================
;; Color Theme and Font
;;=================================================================
;;----------------------
;; color theme
;;----------------------
;; (load-theme 'zenburn t)

(when (require 'color-theme nil t)
(color-theme-initialize))
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")

;;Zenburn For Non-Terminal
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes (quote ("be7eadb2971d1057396c20e2eebaa08ec4bfd1efe9382c12917c6fe24352b7c1" default))))

;;Molokai
;; (setq custom-theme-directory "~/.emacs.d/themes")
;; (load-theme 'molokai t)
;; (enable-theme 'molokai)

;; Solarized
;; (setq custom-theme-directory "~/.emacs.d/themes/emacs-color-theme-solarized")
;; (load-theme 'solarized-dark t)

;; apribase
;; (setq custom-theme-directory "~/.emacs.d/themes")
;; (require 'apribase-theme)


;;----------------------
;;font
;;----------------------
(set-face-attribute 'default nil
                    :family "Ricty Diminished Discord"
                    :height 200)
;;----------------------------------------------
;; Background Color for Region
;;----------------------------------------------
(set-face-background 'region "darkgreen")

;;----------------------------------------------
;; powerline colors
;;http://blog.shibayu36.org/entry/2014/02/11/160945
;;----------------------------------------------
;;; I must require these two elisps before loading powerline...
(require 'elscreen)
(require 'smartrep)

(require 'powerline)

(set-face-attribute 'mode-line nil
                    :foreground "#fff"
                    :background "#FF0066"
                    :box nil)

(set-face-attribute 'powerline-active1 nil
                    :foreground "#000"
                    :background "#FF6699"
                    :inherit 'mode-line)

(set-face-attribute 'powerline-active2 nil
                    :foreground "#000"
                    :background "#ffaeb9"
                    :inherit 'mode-line)

(powerline-default-theme)

;;; modeの名前を自分で再定義
(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (flymake-mode . " Fm")
    (paredit-mode . "")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (undo-tree-mode . "")
    (git-gutter-mode . "")
    (anzu-mode . "")
    (yas-minor-mode . "")
    (guide-key-mode . "")

    ;; Major modes
    (fundamental-mode . "Fund")
    (dired-mode . "Dir")
    (lisp-interaction-mode . "Li")
    (cperl-mode . "Pl")
    (python-mode . "Py")
    (ruby-mode   . "Rb")
    (emacs-lisp-mode . "El")
    (markdown-mode . "Md")))

(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          (when (eq mode major-mode)
            (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)

;;----------------------------------------------
;; powerline simplify the display
;;http://d.hatena.ne.jp/syohex/20130131/1359646452
;;----------------------------------------------
(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (yas-minor-mode . " Ys")
    (paredit-mode . " Pe")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (undo-tree-mode . " Ut")
    (elisp-slime-nav-mode . " EN")
    (helm-gtags-mode . " HG")
    (flymake-mode . " Fm")
    ;; Major modes
    (lisp-interaction-mode . "Li")
    (python-mode . "Py")
    (ruby-mode   . "Rb")
    (emacs-lisp-mode . "El")
    (markdown-mode . "Md")))

(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          (when (eq mode major-mode)
            (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)


;;----------------------------------------------
;; powerline customize what info to show
;; http://blog.shibayu36.org/entry/2014/04/01/094543
;;----------------------------------------------
(defun shorten-directory (dir max-length)
  "Show up to `max-length' characters of a directory name `dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))

(defun powerline-my-theme ()
  "Setup the my mode-line."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (mode-line (if active 'mode-line 'mode-line-inactive))
                          (face1 (if active 'powerline-active1 'powerline-inactive1))
                          (face2 (if active 'powerline-active2 'powerline-inactive2))
                          (separator-left (intern (format "powerline-%s-%s"
                                                          powerline-default-separator
                                                          (car powerline-default-separator-dir))))
                          (separator-right (intern (format "powerline-%s-%s"
                                                           powerline-default-separator
                                                           (cdr powerline-default-separator-dir))))
                          (lhs (list (powerline-raw "%*" nil 'l)
                                     (powerline-buffer-size nil 'l)
                                     (powerline-raw mode-line-mule-info nil 'l)
                                     ;;; !!! ここから書き換えた !!!
                                     (powerline-raw
                                      (shorten-directory default-directory 15)
                                      nil 'l)
                                     (powerline-buffer-id nil 'r)
                                     ;;; !!! ここまで書き換えた !!!
                                     (when (and (boundp 'which-func-mode) which-func-mode)
                                       (powerline-raw which-func-format nil 'l))
                                     (powerline-raw " ")
                                     (funcall separator-left mode-line face1)
                                     (when (boundp 'erc-modified-channels-object)
                                       (powerline-raw erc-modified-channels-object face1 'l))
                                     (powerline-major-mode face1 'l)
                                     (powerline-process face1)
                                     (powerline-minor-modes face1 'l)
                                     (powerline-narrow face1 'l)
                                     (powerline-raw " " face1)
                                     (funcall separator-left face1 face2)
                                     (powerline-vc face2 'r)))
                          (rhs (list (powerline-raw global-mode-string face2 'r)
                                     (funcall separator-right face2 face1)
                                     (powerline-raw "%4l" face1 'l)
                                     (powerline-raw ":" face1 'l)
                                     (powerline-raw "%3c" face1 'r)
                                     (funcall separator-right face1 mode-line)
                                     (powerline-raw " ")
                                     (powerline-raw "%6p" nil 'r)
                                     (powerline-hud face2 face1))))
                     (concat (powerline-render lhs)
                             (powerline-fill face2 (powerline-width rhs))
                             (powerline-render rhs)))))))






;;=============================================
;; Manipulating Frame and Window
;;=============================================

;; ウィンドウ移動
;;http://fukuyama.co/window-number
(require 'window-number)
(window-number-meta-mode)

;; ウィンドウ間の移動
;;http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part16
;; (define-prefix-command 'windmove-map)
;;     (global-set-key (kbd "C-t") 'windmove-map)
;;     (define-key windmove-map "h" 'windmove-left)
;;     (define-key windmove-map "j" 'windmove-down)
;;     (define-key windmove-map "k" 'windmove-up)
;;     (define-key windmove-map "l" 'windmove-right)


;;----------------------------------
;; elscreen
;;----------------------------------
;;; プレフィクスキーはC-z
(setq elscreen-prefix-key (kbd "C-'"))
(elscreen-start)
;;; タブの先頭に[X]を表示しない
(setq elscreen-tab-display-kill-screen nil)
;;; header-lineの先頭に[<->]を表示しない
(setq elscreen-tab-display-control nil)
;;; バッファ名・モード名からタブに表示させる内容を決定する(デフォルト設定)
(setq elscreen-buffer-to-nickname-alist
      '(("^dired-mode$" .
         (lambda ()
           (format "Dired(%s)" dired-directory)))
        ("^Info-mode$" .
         (lambda ()
           (format "Info(%s)" (file-name-nondirectory Info-current-file))))
        ("^mew-draft-mode$" .
         (lambda ()
           (format "Mew(%s)" (buffer-name (current-buffer)))))
        ("^mew-" . "Mew")
        ("^irchat-" . "IRChat")
        ("^liece-" . "Liece")
        ("^lookup-" . "Lookup")))
(setq elscreen-mode-to-nickname-alist
      '(("[Ss]hell" . "shell")
        ("compilation" . "compile")
        ("-telnet" . "telnet")
        ("dict" . "OnlineDict")
        ("*WL:Message*" . "Wanderlust")))

;; タブ移動を簡単に
;; (define-key global-map (kbd "M-t") 'elscreen-next)

;;----------------------------------------------
;; elscreen keybind
;;http://qiita.com/saku/items/6ef40a0bbaadb2cffbce
;;http://blog.iss.ms/2010/02/25/121855
;;http://d.hatena.ne.jp/kobapan/20090429/1259971276
;;http://sleepboy-zzz.blogspot.co.uk/2012/11/emacs.html
;;----------------------------------------------
(define-key global-map (kbd "M-t") 'elscreen-create)
(define-key global-map (kbd "M-T") 'elscreen-clone)
(define-key global-map (kbd "<C-tab>") 'elscreen-next)
(define-key global-map (kbd "<C-S-tab>")'elscreen-previous)
(define-key org-mode-map (kbd "<C-tab>") 'elscreen-next)
(define-key org-mode-map (kbd "<C-S-tab>")'elscreen-previous)
(define-key org-mode-map (kbd "C-'")'helm-elscreen)

;;----------------------------------------------
;; helm-elscreen kenbind
;;----------------------------------------------
(define-key global-map (kbd "C-'") 'helm-elscreen)

;;----------------------------------------------
;; elscreen resume the last buffer on kill buffer
;; http://qiita.com/fujimisakari/items/d7f1b904de11dcb018c3
;;----------------------------------------------
;; 直近バッファ選定時の無視リスト
(defvar elscreen-ignore-buffer-list
 '("*scratch*" "*Backtrace*" "*Colors*" "*Faces*" "*Compile-Log*" "*Packages*" "*vc-" "*Minibuf-" "*Messages" "*WL:Message"))
;; elscreen用バッファ削除
(defun kill-buffer-for-elscreen ()
  (interactive)
  (kill-buffer)
  (let* ((next-buffer nil)
         (re (regexp-opt elscreen-ignore-buffer-list))
         (next-buffer-list (mapcar (lambda (buf)
                                     (let ((name (buffer-name buf)))
                                       (when (not (string-match re name))
                                         name)))
                                   (buffer-list))))
    (dolist (buf next-buffer-list)
      (if (equal next-buffer nil)
          (setq next-buffer buf)))
    (switch-to-buffer next-buffer)))
(global-set-key (kbd "C-x k") 'kill-buffer-for-elscreen)             ; カレントバッファを閉じる

;;----------------------------------
;; elscreen_Old
;;----------------------------------
;; (setq elscreen-prefix-key (kbd "M-l"))
;; (when (require 'elscreen nil t)
;;   (if window-system
;;       (define-key elscreen-map (kbd "M-z") 'iconify-or-deiconify-frame)
;;     (define-key elscreen-map (kbd "M-z") 'suspend-emacs)))
;; ;; タブを表示(非表示にする場合は nil を設定する)
;; (setq elscreen-display-tab t)

;; (elscreen-start)

;; ;; 自動でスクリーンを作成
;; ;(defmacro elscreen-create-automatically (ad-do-it)
;; ;  `(if (not (elscreen-one-screen-p))
;; ;       ,ad-do-it
;; ;     (elscreen-create)
;; ;     (elscreen-notify-screen-modification 'force-immediately)
;; ;     (elscreen-message "New screen is automatically created")))
;; ;(defadvice elscreen-next (around elscreen-create-automatically activate)
;; ;  (elscreen-create-automatically ad-do-it))

;; ;(defadvice elscreen-previous (around elscreen-create-automatically activate)
;; ;  (elscreen-create-automatically ad-do-it))

;; ;(defadvice elscreen-toggle (around elscreen-create-automatically activate)
;; ;  (elscreen-create-automatically ad-do-it))

;; ;; タブ移動を簡単に
;; (define-key global-map (kbd "M-t") 'elscreen-next)

;;----------------------------------
;;popwin.el (pop up anything bugger)
;;----------------------------------
;; (require 'popwin)
;; (setq display-buffer-function 'popwin:display-buffer)

;; ;; for anything
;; (setq anything-samewindow nil)
;; (push '("*anything*" :height 30) popwin:special-display-config)

;; ;; for moccur
;; (push '("*Moccur*" :position right :width 80) popwin:special-display-config)

;;----------------------------------
;; smooth scroll
;;----------------------------------
;; ;;; smooth-scroll
;; (add-to-list 'load-path "~/.emacs.d/public_repos/smooth-scroll.el/")
;; (require 'smooth-scroll)
;; (smooth-scroll-mode t)

;;----------------------------------
;; split into 3 windows
;;----------------------------------
(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-vertically)
    (progn
      (split-window-vertically
       (- (window-height) (/ (window-height) num_wins)))
      (split-window-vertically-n (- num_wins 1)))))
(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-horizontally)
    (progn
      (split-window-horizontally
       (- (window-width) (/ (window-width) num_wins)))
      (split-window-horizontally-n (- num_wins 1)))))
(global-set-key "\C-x#" '(lambda ()
                           (interactive)
                           (split-window-vertically-n 3)))
(global-set-key "\C-x$" '(lambda ()
                           (interactive)
                           (split-window-horizontally-n 3)))

;;----------------------------------------------
;; toggle window split
;;----------------------------------------------
(defun window-toggle-division ()
  "ウィンドウ 2 分割時に、縦分割<->横分割"
  (interactive)
  (unless (= (count-windows 1) 2)
    (error "ウィンドウが 2 分割されていません。"))
  (let (before-height (other-buf (window-buffer (next-window))))
    (setq before-height (window-height))
    (delete-other-windows)

    (if (= (window-height) before-height)
        (split-window-vertically)
      (split-window-horizontally)
      )

    (switch-to-buffer-other-window other-buf)
    (other-window -1)))

;;----------------------------------------------
;; swap buffers
;; http://rubikitch.com/2015/05/10/swap-buffers/
;;----------------------------------------------
(defun swap-buffers-keep-focus ()
  (interactive)
  (swap-buffers t))
;;; 無設定で使えるが、swap-screenに倣ってf2/S-f2に割り当てる
(global-set-key [f2] 'swap-buffers-keep-focus)
(global-set-key [S-f2] 'swap-buffers)


;;----------------------------------------------
;; Working with Terminal
;;----------------------------------------------
;; (setq ns-pop-up-frames nil)

;;----------------------------------------------
;; persp-mdde
;;----------------------------------------------
;; (setq persp-keymap-prefix (kbd "C-c p")) ;prefix
;; (setq persp-add-on-switch-or-display t) ;バッファを切り替えたら見えるようにする
;; (persp-mode 1)
;; (defun persp-register-buffers-on-create ()
;;   (interactive)
;;   (dolist (bufname (condition-case _
;;                        (helm-comp-read
;;                         "Buffers: "
;;                         (mapcar 'buffer-name (buffer-list))
;;                         :must-match t
;;                         :marked-candidates t)
;;                      (quit nil)))
;;     (persp-add-buffer (get-buffer bufname))))
;; (add-hook 'persp-activated-hook 'persp-register-buffers-on-create)


;;----------------------------------------------
;; hiwin.el
;;----------------------------------------------
;; (hiwin-activate)                           ;; hiwin-modeを有効化
;; (set-face-background 'hiwin-face "gray80") ;; 非アクティブウィンドウの背景色を設定

;;=============================================
;; For HTML and CSS
;;=============================================
;;----------------------------------------------
;; register the files to open with web-mod
;;----------------------------------------------
(setq auto-mode-alist
      (append '(
                ("\\.\\(html\\|xhtml\\|shtml\\|tpl\\|tt\\|ms\\)\\'" . web-mode)
                ("\\.php\\'" . php-mode)
                )
              auto-mode-alist))

;;----------------------------------------------
;; web-modeの設定
;; http://yanmoo.blogspot.co.uk/2013/06/html5web-mode.html
;; https://github.com/fxbois/web-mode/issues/237
;;----------------------------------------------
(require 'web-mode)
(defun web-mode-hook ()
  "Hooks for Web mode."
  ;; 変更日時の自動修正
  (setq time-stamp-line-limit -200)
  (if (not (memq 'time-stamp write-file-hooks))
      (setq write-file-hooks
            (cons 'time-stamp write-file-hooks)))
  (setq time-stamp-format " %3a %3b %02d %02H:%02M:%02S %:y %Z")
  (setq time-stamp-start "Last modified:")
  (setq time-stamp-end "$")
  ;; web-modeの設定
  (setq web-mode-markup-indent-offset 2) ;; html indent
  (setq web-mode-css-indent-offset 2)    ;; css indent
  (setq web-mode-code-indent-offset 4)   ;; script indent(js,php,etc..)
  (setq web-mode-enable-current-element-highlight t)
  ;; htmlの内容をインデント
  ;; TEXTAREA等の中身をインデントすると副作用が起こったりするので
  ;; デフォルトではインデントしない
  ;;(setq web-mode-indent-style 2)
  ;; コメントのスタイル
  ;;   1:htmlのコメントスタイル(default)
  ;;   2:テンプレートエンジンのコメントスタイル
  ;;      (Ex. {# django comment #},{* smarty comment *},{{-- blade comment --}})
  (setq web-mode-comment-style 2)
  ;; 終了タグの自動補完をしない
  ;;(setq web-mode-disable-auto-pairing t)
  ;; color:#ff0000;等とした場合に指定した色をbgに表示しない
  ;;(setq web-mode-disable-css-colorization t)
  ;;css,js,php,etc..の範囲をbg色で表示
  ;; (setq web-mode-enable-block-faces t)
  ;; (custom-set-faces
  ;;  '(web-mode-server-face
  ;;    ((t (:background "grey"))))                  ; template Blockの背景色
  ;;  '(web-mode-css-face
  ;;    ((t (:background "grey18"))))                ; CSS Blockの背景色
  ;;  '(web-mode-javascript-face
  ;;    ((t (:background "grey36"))))                ; javascript Blockの背景色
  ;;  )
  ;;(setq web-mode-enable-heredoc-fontification t)
)
(add-hook 'web-mode-hook  'web-mode-hook)
;; 色の設定
(custom-set-faces
 '(web-mode-doctype-face
   ((t (:foreground "#82AE46"))))                          ; doctype
 '(web-mode-html-tag-face
   ((t (:foreground "#E6B422" :weight bold))))             ; 要素名
 '(web-mode-html-attr-name-face
   ((t (:foreground "#C97586"))))                          ; 属性名など
 '(web-mode-html-attr-value-face
   ((t (:foreground "#82AE46"))))                          ; 属性値
 '(web-mode-comment-face
   ((t (:foreground "#D9333F"))))                          ; コメント
 '(web-mode-server-comment-face
   ((t (:foreground "#D9333F"))))                          ; コメント
 '(web-mode-css-rule-face
   ((t (:foreground "#A0D8EF"))))                          ; cssのタグ
 '(web-mode-css-pseudo-class-face
   ((t (:foreground "#FF7F00"))))                          ; css 疑似クラス
 '(web-mode-css-at-rule-face
   ((t (:foreground "#FF7F00"))))                          ; cssのタグ
)
;;----------------------------------------------
;; disable tab for web-mode
;;----------------------------------------------
(add-hook 'web-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))

;;----------------------------------------------
;; tab width
;;----------------------------------------------
;; for-web-mode
(add-hook 'web-mode-hook
          (lambda ()
            (setq-default tab-width 2)))

;;----------------------------------------------
;; rainbow-mode
;;----------------------------------------------
(require 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'scss-mode-hook 'rainbow-mode)
(add-hook 'php-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)

;;----------------------------------------------
;; e-palette
;; http://filmlang.org/soft/emacs/e-palette
;;----------------------------------------------
(require 'e-palette)
(define-key global-map [f2] 'e-palette)

;;----------------------------------------------
;; emmet
;; http://qiita.com/ironsand/items/55f2ced218949efbb1fb
;;----------------------------------------------
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; マークアップ言語全部で使う
(add-hook 'css-mode-hook  'emmet-mode) ;; CSSにも使う
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 4))) ;; indent はスペース2個
(define-key emmet-mode-keymap (kbd "C-j") 'emmet-expand-line) ;; C-j で展開

;; (eval-after-load "emmet-mode"
;;   '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
;; (keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
;; (define-key emmet-mode-keymap (kbd "H-i") 'emmet-expand-line) ;; C-i で展開

;;=============================================
;; For SCSS
;;=============================================
;;----------------------------------------------
;; scss-mode
;; http://cortyuming.hateblo.jp/entry/20120110/p1
;; http://qiita.com/sawamur@github/items/bb50d84af4d01a2eb5c2
;;----------------------------------------------
;; ;; CSS
(defun my-css-electric-pair-brace ()
  (interactive)
  (insert "{")(newline-and-indent)
  (newline-and-indent)
  (insert "}")
  (indent-for-tab-command)
  (previous-line)(indent-for-tab-command)
  )

(defun my-semicolon-ret ()
  (interactive)
  (insert ";")
  (newline-and-indent))

;; ;; scss-mode
;; (autoload 'scss-mode "scss-mode")
;; (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(add-to-list 'auto-mode-alist '("\\.\\(scss\\|css\\)\\'" . scss-mode))
(add-hook 'scss-mode-hook 'ac-css-mode-setup)
(add-hook 'scss-mode-hook
          (lambda ()
            (define-key scss-mode-map "\M-{" 'my-css-electric-pair-brace)
            (define-key scss-mode-map ";" 'my-semicolon-ret)
            (setq css-indent-offset 4)
            (setq scss-compile-at-save nil)
            (setq ac-sources '(ac-source-yasnippet
                               ;; ac-source-words-in-same-mode-buffers
                               ac-source-words-in-all-buffer
                               ac-source-dictionary
                               ))
            (flymake-mode t)
            ))
(add-to-list 'ac-modes 'scss-mode)

;;----------------------------------------------
;; flycheck for SCSS
;;----------------------------------------------
(add-hook 'scss-mode-hook 'flycheck-mode)
'(flycheck-scss-compass t)

;;=============================================
;; For JavaScript
;;=============================================

;;----------------------------------
;; js2-mode
;;----------------------------------
(autoload 'js-mode "js")
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status))
           node)
      (save-excursion
        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ js-indent-level 2))))
        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))
      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-indent-sexp ()
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let* ((inhibit-point-motion-hooks t)
             (parse-status (syntax-ppss (point)))
             (beg (nth 1 parse-status))
             (end-marker (make-marker))
             (end (progn (goto-char beg) (forward-list) (point)))
             (ovl (make-overlay beg end)))
        (set-marker end-marker end)
        (overlay-put ovl 'face 'highlight)
        (goto-char beg)
        (while (< (point) (marker-position end-marker))
          ;; don't reindent blank lines so we don't set the "buffer
          ;; modified" property for nothing
          (beginning-of-line)
          (unless (looking-at "\\s-*$")
            (indent-according-to-mode))
          (forward-line))
        (run-with-timer 0.5 nil '(lambda(ovl)
                                   (delete-overlay ovl)) ovl)))))
(defun my-js2-mode-hook ()
  (require 'js)
  (setq js-indent-level 4
        indent-tabs-mode nil
        c-basic-offset 4)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
 (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  ;; (define-key js2-mode-map [(meta control \;)]
  ;;   '(lambda()
  ;;      (interactive)
  ;;      (insert "/* -----[ ")
  ;;      (save-excursion
  ;;        (insert " ]----- */"))
  ;;      ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;;----------------------------------------------
;; disable tab for js2-mode
;;----------------------------------------------
(add-hook 'js2-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))

;;----------------------------------------------
;; notify when a line exceeds the limit
;; http://rubikitch.com/2014/08/11/column-enforce-mode/
;;----------------------------------------------
(defun js2-mode-hook--column-enforce-mode ()
  (set (make-local-variable 'column-enforce-column) 80)
  (column-enforce-mode 1))
(add-hook 'js2-mode-hook 'js2-mode-hook--column-enforce-mode)


;;----------------------------------
;; Node
;;----------------------------------
;; set the path to node
;; (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

;;----------------------------------
;; jshint
;;----------------------------------
;; set the execution path to jshint
(setq exec-path (append exec-path '("/usr/local/bin")))

;;----------------------------------
;; flymake-jshint.el
;;----------------------------------
;; ;; flymake-jshint.el
;; (add-to-list 'load-path "~/.emacs.d/public_repos/flymake-jshint.el/")

;; (add-hook 'js2-mode-hook '(lambda ()
;;           (require 'flymake-jshint)
;;           (flymake-jshint-load)))

;; for flymake-cursor.el
(custom-set-variables
   '(help-at-pt-timer-delay 0.9)
   '(help-at-pt-display-when-idle '(flymake-overlay)))

;;----------------------------------
;; flycheck
;;----------------------------------
;; flycheck
;;http://syati.info/?p=2096
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;;----------------------
;; Tern.js
;;----------------------
;; set the path to tern
(setq exec-path (append exec-path '("/usr/local/bin")))

;; set the path to node
;; (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

(autoload 'tern-mode "tern.el" nil t)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-hook 'js2-mode-hook
          (lambda ()
            (tern-mode t)))

(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

;;=============================================
;; For Perl
;;=============================================
;;----------------------------------------------
;; register files to open with cperl-mode
;; http://blog.iss.ms/2010/06/15/211445
;;----------------------------------------------
(defalias 'perl-mode 'cperl-mode)
(setq auto-mode-alist (append '(("\\.psgi$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.cgi$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.t$" . cperl-mode)) auto-mode-alist))

;;----------------------------------------------
;; plenv
;;----------------------------------------------
(require 'plenv)
;; (plenv-global "5.10.1")

;;----------------------------------------------
;; flycheck
;; http://m0t0k1ch1st0ry.com/blog/2014/07/07/flycheck/
;; https://github.com/flycheck/flycheck/issues/567
;; http://hitode909.hatenablog.com/entry/2013/08/04/194929
;;----------------------------------------------

(require 'flycheck)
(flycheck-define-checker perl-project-libs
  "A perl syntax checker."
  :command ("perl"
            "-MProject::Libs lib_dirs => [qw(nexus_lib_perl)]"
            "-wc"
            source-inplace)
  :error-patterns ((error line-start
                          (minimal-match (message))
                          " at " (file-name) " line " line
                          (or "." (and ", " (zero-or-more not-newline)))
                          line-end))
  :modes (cperl-mode))

(add-hook 'cperl-mode-hook
          (lambda ()
            (flycheck-mode t)
            (setq flycheck-checker 'perl-project-libs)))


;;----------------------------------------------
;; flycheck
;;http://blog.s2factory.co.jp/arakawa/2014/12/emacs-perl.html
;;----------------------------------------------
;; (flycheck-define-checker perl-project-libs
;;   "A perl syntax checker."
;;   :command ("perl"
;;             "-MProject::Libs lib_dirs => [qw(local/lib/perl5)]"
;;             "-wc"
;;             source-inplace)
;;   :error-patterns ((error line-start
;;                           (minimal-match (message))
;;                           " at " (file-name) " line " line
;;                           (or "." (and ", " (zero-or-more not-newline)))
;;                           line-end))
;;   :modes (cperl-mode))

;; (add-hook 'cperl-mode-hook
;;           (lambda ()
;;             (flycheck-mode t)
;;             (setq flycheck-checker 'perl-project-libs)))

;; (with-eval-after-load "flycheck"
;;   (flycheck-define-checker
;;    perl-project-libs
;;    "A perl syntax checker."
;;    ;; :command ("perl" "-MProject::Libs" "-wc" source-inplace)
;;    ;; :command ("ssh" "pelican" "perl" "-wc" source-inplace)
;;    ;; :command ("ssh" "pelican" "perl" "-MProject::Libs" "-wc" source-inplace)
;;    ;; :command ("/Users/shun/.plenv/shims/perl" "-wc" source-inplace)
;;    ;; :command ("/Users/shun/.plenv/shims/perl" "-MProject::Libs" "-wc" source-inplace)
;;    ;; :command ("/Users/shun/.plenv/shims/perl" "-MProject::Libs lib_dirs => [qw(extlib vendor modules/*lib)]" "-wc" source-inplace)
;;    ;; :command ("/Users/shun/.plenv/shims/perl" "-MProject::Libs lib_dirs => [qw(/Users/shun/Remotes/nexus/lib/perl)]" "-wc" source-inplace)
;;    :command ("/Users/shun/.plenv/shims/perl" "-I/Users/shun/Remotes/nexus/lib/perl" "-wc" source-inplace)

;;    :error-patterns ((error line-start
;;                            (minimal-match (message))
;;                            " at " (file-name) " line " line
;;                            (or "." (and ", " (zero-or-more not-newline)))
;;                            line-end))
;;    :modes (cperl-mode)))
;; (add-hook 'cperl-mode-hook
;;           (lambda ()
;;             (unless (or (and (fboundp 'tramp-tramp-file-p)
;;                              (tramp-tramp-file-p buffer-file-name))
;;                         (string-match "sudo:.*:" (buffer-file-name)))
;;               (progn
;;                 (flycheck-mode t)
;;                 (setq flycheck-checker 'perl-project-libs)))))

;; (with-eval-after-load "flycheck"
;;   (flycheck-define-checker
;;    perl-project-libs
;;    "A perl syntax checker."
;;    ;; :command ("ssh" "pelican" "perl" "-MProject/Libs" "-w" "-c" source-inplace)
;;    :command ("ssh" "pelican" "perl" "-w" "-c" source-inplace)

;;    :error-patterns ((error line-start
;;                            (minimal-match (message))
;;                            " at " (file-name) " line " line
;;                            (or "." (and ", " (zero-or-more not-newline)))
;;                            line-end))
;;    :modes (cperl-mode)))

;; (add-hook 'cperl-mode-hook 'flycheck-mode)


;;----------------------------------------------
;; flymake
;; http://hitode909.hatenablog.com/entry/2013/08/04/194929
;; https://github.com/hitode909/emacs-config/blob/master/inits/50-perl-config.el
;;----------------------------------------------
;; (defalias 'perl-mode 'cperl-mode)
;; (setq auto-mode-alist (cons '("\\.t$" . cperl-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.cgi$" . cperl-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.psgi$" . cperl-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("cpanfile$" . cperl-mode) auto-mode-alist))

;; (defun run-perl-test ()
;;   "test実行します"
;;   (interactive)
;;   (compile (format "cd %s; carton exec -- perl %s" (vc-git-root default-directory) (buffer-file-name (current-buffer)))))

;; (defun run-perl-method-test ()
;;   (interactive)
;;   (let (
;;         (command compile-command)
;;         (test-method nil))
;;     (save-excursion
;;       (when (or
;;              (re-search-backward "\\bsub\s+\\([_[:alpha:]]+\\)\s*:\s*Test" nil t)
;;              (re-search-forward "\\bsub\s+\\([_[:alpha:]]+\\)\s*:\s*Test" nil t))
;;         (setq test-method (match-string 1))))
;;     (if test-method
;;         (compile (format "cd  %s; TEST_METHOD=%s carton exec -- perl %s"
;;                          (vc-git-root default-directory)
;;                          (shell-quote-argument test-method)
;;                          (buffer-file-name (current-buffer))))
;;       (let ((a 1))
;;         (save-excursion
;;           (when (or
;;                  (re-search-backward "^subtest\s+['\"]?\\([^'\"\s]+\\)['\"]?\s*=>\s*sub" nil t)
;;                  (re-search-foreward "^subtest\s+['\"]?\\([^'\"\s]+\\)['\"]?\s*=>\s*sub" nil t))
;;             (setq test-method (match-string 1))))
;;         (if test-method
;;             (compile (format "cd  %s; SUBTEST_FILTER=%s carton exec -- perl %s"
;;                              (vc-git-root default-directory)
;;                              (shell-quote-argument test-method)
;;                              (buffer-file-name (current-buffer)))))
;;         (message "not match")
;;         ))))

;; (defun popup-editor-perl-use ()
;;   (interactive)
;;   (let* ((module-name nil))
;;     (cond ((use-region-p)
;;            (setq module-name (buffer-substring (region-beginning) (region-end)))
;;            (keyboard-escape-quit))
;;           (t
;;            (setq module-name (thing-at-point 'symbol))))
;;     (kill-new (concat "use " module-name ";"))
;;     (popwin:popup-buffer (current-buffer) :height 0.4)
;;     (re-search-backward "^use " nil t)
;;     (next-line)))

;; (add-hook 'cperl-mode-hook
;;           '(lambda ()
;;              (setq indent-tabs-mode nil)
;;              (setq cperl-close-paren-offset -4)
;;              (setq cperl-continued-statement-offset 4)
;;              (setq cperl-indent-level 4)
;;              (setq cperl-indent-parens-as-block t)
;;              (setq cperl-tab-always-indent t)
;;              (setq cperl-indent-parens-as-block t)

;;              (define-key cperl-mode-map [(super T)] 'run-perl-test)
;;              (define-key cperl-mode-map [(super t)] 'run-perl-method-test)

;;              (local-set-key (kbd "C-c C-c C-u") 'popup-editor-perl-use)

;;              (font-lock-add-keywords
;;               'cperl-mode
;;               '(
;;                 ("!" . font-lock-warning-face)
;;                 (":" . font-lock-warning-face)
;;                 ("TODO" 0 'font-lock-warning-face)
;;                 ("XXX" 0 'font-lock-warning-face)
;;                 ("Hatean" 0 'font-lock-warning-face)
;;                 ))

;;              ;; なんか動かない
;;              ;; (setq plcmp-use-keymap nil)
;;              ;; (require 'perl-completion)
;;              ;; (perl-completion-mode t)
;;              ;; (add-to-list 'ac-sources 'ac-source-perl-completion)

;;              (require 'editortools)

;;              ))

;; ;; plenv

;; (require 'plenv)
;; (plenv-global "5.10.1")

;; ;; flymake


;; (defun flymake-perl-init ()
;;   (let* ((root (expand-file-name (or (vc-git-root default-directory) default-directory))))
;;     (list "perl" (list "-MProject::Libs lib_dirs => [qw(local/lib/perl5), glob(qw(nexus/*/lib))]" "-wc"  buffer-file-name) root)
;;     ))

;; (push '(".+\\.p[ml]$" flymake-perl-init) flymake-allowed-file-name-masks)
;; (push '(".+\\.psgi$" flymake-perl-init) flymake-allowed-file-name-masks)
;; (push '(".+\\.t$" flymake-perl-init) flymake-allowed-file-name-masks)

;; (add-hook 'cperl-mode-hook (lambda () (flymake-mode t)))


;;----------------------------------------------
;; flymake
;; https://github.com/sugyan/dotfiles/blob/b1401ad505495239f15b4ff95d8600f9ae36ebc0/.emacs.d/inits/21-perl.el
;;----------------------------------------------

;; ;;; Perl

;; ;; cperl-mode
;; (defalias 'perl-mode 'cperl-mode)
;; (add-to-list 'auto-mode-alist '("\\.psgi$" . cperl-mode))
;; (add-to-list 'auto-mode-alist '("\\.t\\'"  . cperl-mode))
;; (eval-after-load "cperl-mode"
;;   '(progn
;;      (cperl-set-style "PerlStyle")
;;      (define-key cperl-mode-map (kbd "C-m") 'newline-and-indent)
;;      (define-key cperl-mode-map (kbd "(") nil)
;;      (define-key cperl-mode-map (kbd "{") nil)
;;      (define-key cperl-mode-map (kbd "[") nil)
;;      (define-key cperl-mode-map (kbd "M-n") 'flymake-goto-next-error)
;;      (define-key cperl-mode-map (kbd "M-p") 'flymake-goto-prev-error)))
;; (custom-set-variables
;;  '(cperl-indent-parens-as-block t)
;;  '(cperl-close-paren-offset     -4))

;; ;; perl-completion
;; ;; (auto-install-from-emacswiki "perl-completion.el")
;; (autoload 'perl-completion-mode "perl-completion" nil t)
;; (eval-after-load "perl-completion"
;;   '(progn
;;      (defadvice flymake-start-syntax-check-process (around flymake-start-syntax-check-lib-path activate) (plcmp-with-set-perl5-lib ad-do-it))
;;      (define-key plcmp-mode-map (kbd "M-TAB") nil)
;;      (define-key plcmp-mode-map (kbd "M-C-o") 'plcmp-cmd-smart-complete)))

;; ;; hook
;; (defun my-cperl-mode-hook ()
;;   (perl-completion-mode t)
;;   (flymake-mode t)
;;   (when (boundp 'auto-complete-mode)
;;     (defvar ac-source-my-perl-completion
;;       '((candidates . plcmp-ac-make-cands)))
;;     (add-to-list 'ac-sources 'ac-source-my-perl-completion)))
;; (add-hook 'cperl-mode-hook 'my-cperl-mode-hook)


;;----------------------------------------------
;; setting for the indent in cperl-mode
;; http://oinume.hatenablog.com/entry/wp/384
;;----------------------------------------------
(setq cperl-indent-level 4
      cperl-continued-statement-offset 4
      cperl-close-paren-offset -4
      cperl-label-offset -4
      cperl-comment-column 40
      cperl-highlight-variables-indiscriminately t ;;変数に色つける
      cperl-indent-parens-as-block t ;;無名ハッシュインデント
      cperl-tab-always-indent nil
      cperl-font-lock t)
(add-hook 'cperl-mode-hook
          '(lambda ()
             (progn
               (setq indent-tabs-mode nil)
               (setq tab-width nil))))

;; ----------------------------------------------
;; cperl-mode indent
;; http://wp.hebon.net/emacs/?p=33
;; ----------------------------------------------
;; 無名ハッシュ、無名サブルーチンのインデント調整
(setq cperl-indent-subs-specially nil)


;; 途中改行時のインデント
(setq cperl-continued-statement-offset 4)

;;----------------------------------------------
;;  setting for the colors
;;  http://d.hatena.ne.jp/holidays-l/20070528/p1
;;----------------------------------------------
;; (set-face-italic-p 'cperl-hash-face nil)
;; (set-face-background 'cperl-hash-face nil)
;; (set-face-background 'cperl-array-face nil)
;; (setq cperl-array-face 'font-lock-variable-name-face)
;; (setq cperl-hash-face 'font-variable-name-face)


;; setting for perl
;; http://sugyan.com/presentations/perl-casual-06/#/11
;; (defalias 'perl-mode 'cperl-mode)

;; (custom-set-variables
;;  '(cperl-indent-parens-as-block t)
;;  '(cperl-close-paren-offset     -4)
;;  '(cperl-indent-subs-specially  nil))

;; (with-eval-after-load "cperl-mode"
;;   (eval
;;    '(progn
;;       (cperl-set-style "PerlStyle"))))


;;----------------------------------------------
;; flymake config for perl
;;----------------------------------------------
;;http://blog.kentarok.org/entry/20080810/1218369556

;; ;; Perl用設定
;; ;; http://unknownplace.org/memo/2007/12/21#e001
;; (defvar flymake-perl-err-line-patterns
;;   '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

;; (defconst flymake-allowed-perl-file-name-masks
;;   '(("\\.pl$" flymake-perl-init)
;;     ("\\.pm$" flymake-perl-init)
;;     ("\\.t$" flymake-perl-init)))

;; (defun flymake-perl-init ()
;;   (let** ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "perl" (list "-wc" local-file))))

;; (defun flymake-perl-load ()
;;   (interactive)
;;   (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
;;     (setq flymake-check-was-interrupted t))
;;   (ad-activate 'flymake-post-syntax-check)
;;   (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
;;   (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
;;   (set-perl5lib)
;;   (flymake-mode t))

;; (add-hook 'cperl-mode-hook 'flymake-perl-load)



;;----------------------------------------------
;; perly-sense
;;----------------------------------------------
;; executino path to perly_sense
;; (setq exec-path (append exec-path '("Users/shun/perl5/perlbrew/perls/perl-5.10.1/bin/")))

;; *** PerlySense Config ***

;; ** PerlySense **
;; The PerlySense prefix key (unset only if needed, like for \C-o)
;; (global-unset-key "\C-o")
;; (setq ps/key-prefix "\C-o")


;; ** Flymake **
;; Load flymake if t
;; Flymake must be installed.
;; It is included in Emacs 22
;;     (or http://flymake.sourceforge.net/, put flymake.el in your load-path)
;; (setq ps/load-flymake t)
;; Note: more flymake config below, after loading PerlySense


;; *** PerlySense load (don't touch) ***
;; (setq ps/external-dir (shell-command-to-string "perly_sense external_dir"))
;; (if (string-match "Devel.PerlySense.external" ps/external-dir)
;; 	(progn
;; 	  (message
;; 	   "PerlySense elisp files  at (%s) according to perly_sense, loading..."
;; 	   ps/external-dir)
;; 	  (setq load-path (cons
;; 					   (expand-file-name
;; 						(format "%s/%s" ps/external-dir "emacs")
;; 						) load-path))
;; 	  (load "perly-sense")
;; 	  )
;;   (message "Could not identify PerlySense install dir.
;;     Is Devel::PerlySense installed properly?
;;     Does 'perly_sense external_dir' give you a proper directory? (%s)" ps/external-dir)
;;   )


;; ;; ** Flymake Config **
;; ;; If you only want syntax check whenever you save, not continously
;; (setq flymake-no-changes-timeout 9999)
;; (setq flymake-start-syntax-check-on-newline nil)

;; ;; ** Code Coverage Visualization **
;; ;; If you have a Devel::CoverX::Covered database handy and want to
;; ;; display the sub coverage in the source, set this to t
;; (setq ps/enable-test-coverage-visualization nil)

;; ;; ** Color Config **
;; ;; Emacs named colors: http://www.geocities.com/kensanata/colors.html
;; ;; The following colors work fine with a white X11
;; ;; background. They may not look that great on a console with the
;; ;; default color scheme.
;; (set-face-background 'flymake-errline "antique white")
;; (set-face-background 'flymake-warnline "lavender")
;; (set-face-background 'dropdown-list-face "lightgrey")
;; (set-face-background 'dropdown-list-selection-face "grey")


;; ;; ** Misc Config **

;; ;; Run calls to perly_sense as a prepared shell command. Experimental
;; ;; optimization, please try it out.
;; (setq ps/use-prepare-shell-command t)

;; *** PerlySense End ***

;;----------------------------------------------
;; perl-completion
;;----------------------------------------------
;; (defun perl-completion-hook()
;;   (when ( require 'perl-completion nil t)
;;     (perl-completion-mode t)
;;     (when (require 'auto-compelte nil t)
;;       (auto-compelte-mode t)
;;       (make-variable-buffer-local 'ac-sources)
;;       (setq ac-sources
;; 	    '(ac-source-perl-completion)))))
;; (add-hook 'cperl-mode-hook 'perl-completion-hook)

;;----------------------------------------------
;; plsense
;;----------------------------------------------
(require 'plsense)

;; キーバインド
(setq plsense-popup-help-key "C-:")
(setq plsense-display-help-buffer-key "M-:")
(setq plsense-jump-to-definition-key "C->")

;; 必要に応じて適宜カスタマイズして下さい。以下のS式を評価することで項目についての情報が得られます。
;; (customize-group "plsense")

;; 推奨設定を行う
(plsense-config-default)


;;----------------------------------------------
;; PerlTidy
;;----------------------------------------------
(defun perltidy-region ()               ;選択regionをperltidy
   "Run perltidy on the current region."
   (interactive)
   (save-excursion
     (shell-command-on-region (point) (mark) "perltidy -q" nil t)))
(defun perltidy-defun ()                ;開いているソースをperltidy
  "Run perltidy on the current defun."
  (interactive)
  (save-excursion (mark-defun)
                  (perltidy-region)))


;;=============================================
;; For php
;;=============================================
;;----------------------------------------------
;; php mode
;; http://qiita.com/kyanagimoto/items/8d3c81ae806f74bfae1b
;;----------------------------------------------
;; php-mode
(require 'php-mode)


;;=============================================
;; For yaml
;;=============================================
(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))




;;=============================================
;; Miscellenious
;;=============================================
