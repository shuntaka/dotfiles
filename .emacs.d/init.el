;;##########################################################################
;; Index
;;##########################################################################
;; Basic Settings
;; 2. Package Management
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
;; Helm
;; Manipulating  Frame and Window
;; Multi Term
;; For Git
;; For JavaScript
;; For Perl
;; For Yaml
;; Miscellenious



;;===========================================================================
;; Basic Settings
;;===========================================================================
;;----------------------
;; color theme 
;;----------------------
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
	    :family "Ricty"
            :height 180)

;;----------------------------------------------
;; Background Color for Region
;;----------------------------------------------
(set-face-background 'region "darkgreen")

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


;;----------------------
;;Hilight Parenthesis
;;----------------------
(show-paren-mode t)

;;----------------------
;; Emphasize Parenthesis
;;----------------------
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;;----------------------------------------------
;; ターミナル以外はツーバーとスクロールバーを消す
;;----------------------------------------------
(when window-system
(tool-bar-mode 0)    
(scroll-bar-mode 0))
;; (when (eq system-type 'darwin)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1))

;;----------------------
;; display row  line-number
;;----------------------
(line-number-mode 1)
(column-number-mode 1)

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
(setq-default tab-width 4)

;;----------------------------------------------
;; disable tab for yaml
;;----------------------------------------------
(add-hook 'yaml-mode-hook
		  (lambda ()
		  (setq-default indent-tabs-mode nil)))

;;----------------------------------------------
;; from Emacs Technique Bible Basic Setting
;;----------------------------------------------
;;; 履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; ファイル内のカーソル位置を記憶する
(setq-default save-place t)
(require 'saveplace)

;;; 対応する括弧を光らせる
;;(show-paren-mode t)

;;; シェルに合わせるため、C-hは後退に割り当てる
;;; ヘルプは<f1>
(global-set-key (kbd "C-h") 'delete-backward-char) 

;;; モードラインに時刻を表示する
(display-time)

;;; 行番号・桁番号を表示する
;;(line-number-mode 1)
;;(column-number-mode 1)

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
(setq history-lenght 1000)

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

;; ;;; goto-line ショートカット
;; (global-set-key "\M-g" 'goto-line)

;;----------------------------------------------
;; generic mode
;;----------------------------------------------
(require 'generic-x)


;;----------------------------------------------
;; eww
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

;;=============================================
;;2. Package Management
;;=============================================

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
(add-to-load-path "elisp" "elpa" "conf" "public_repos")

;;----------------------
;; setting for ELPA (package.el)
;;----------------------
;; How to use
;; M-x list-packages
;;     or
;; M-x package-refresh-contents
;; M-x package-initialize "package name"

(package-initialize)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;----------------------
;; auto-install
;;----------------------
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
;; ffap.el open the specified file
;;----------------------
;; e.g. type C-x C-f with the cursor near a file name(e.g. init.el)
;; if it exists, that file is used as the file name to be opened
(ffap-bindings)


;;----------------------
;; uniquify.el
;;----------------------
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;;----------------------
;; iswitchb.el
;;----------------------
;; (iswitchb-mode 1)
;; ;; バッファ読み取り関数を iswitchb にする
;; (setq read-buffer-function 'iswitchb-read-buffer)
;; ;; 部分文字列の代わりに正規表現を使う場合は t に設定する
;; (setq iswitchb-regexp nil)
;; ;; 新しいバッファを作成するときにいちいち聞いてこない
;; (setq iswitchb-prompt-newbuffer nil)

;;----------------------
;; recentf.el
;;----------------------
;; 最近使ったファイルを開く
;; M-x recentf-open-files
;;   ref:「Emacsテクニックバイブル」 p.87
;; Author: rubikitch <rubikitch@ruby-lang.org>
;; Keywords: convenience, files
;; URL: http://www.emacswiki.org/cgi-bin/wiki/download/recentf-ext.el
(setq recentf-max-saved-itemsi 3000)
(setq recentf-exclude '("/TAGS$" "/var/tmp/"))
(require 'recentf-ext)
(global-set-key [?\C-c ?r ?f] 'recentf-open-files)



;;----------------------
;; bookmark.el
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
;; emacsclient
;;----------------------
(server-start)
(defun iconify-emacs-when-server-is-done ()
  (unless server-clients (iconify-frame)))
;; 編集が終了したらEmacsをアイコン化する
;; (add-hook 'server-done-hook 'iconify-emacs-when-server-is-done)
;;  C-x C-cに割り当てる
(global-set-key (kbd "C-x C-c") 'server-edit)
;; M-x exitでEmacsを終了できるようにする
(defalias 'exit 'save-buffers-kill-emacs)

;;----------------------
;; tempbuf.el
;;----------------------
(require 'tempbuf)
;; ファイルを開いたら自動的にtempbufを有効にする
;(add-hook 'find-file-hooks 'turn-on-tempbuf-mode)
;; diredバッファに対してtempbufを有効にする
;(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)

;----------------------------------------------
; 4.12 
;----------------------------------------------

;----------------------------------------------
; sudo-ext.el
;----------------------------------------------
;; (server-start) ;  sudoeditで使う
;; (require 'sudo-ext)




;;=============================================
;; 5. Moving Cursor
;;=============================================

;;----------------------
;; goto-line
;;----------------------
;; (global-set-key "\M-g" 'goto-line)

;;----------------------
;; poin-undo.el
;;----------------------
(require 'point-undo)
(define-key global-map (kbd "<f7>") 'point-undo)
(define-key global-map (kbd "S-<f7>") 'point-redo)

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
(define-key global-map (kbd "<f8>") 'goto-last-change)
(define-key global-map (kbd "S-<f8>") 'goto-last-change-reverse)
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
;; 6 Input Support
;;=============================================

;;----------------------
;; redo+
;;----------------------
(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t) ; 過去のundoがredoされないようにする
(setq undo-limit 600000)
(setq undo-strong-limit 900000)

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
(require 'auto-complete-config)
(global-auto-complete-mode 1)
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


;;=============================================
;; 7. Search and Replace
;;=============================================
;;----------------------
;; Moccur
;;----------------------
(require 'color-moccur)
(setq moccur-split-word t)

;;----------------------------------------------
;; ace-isearch
;;----------------------------------------------
;;http://rubikitch.com/2014/10/08/ace-isearch/
(add-to-list 'load-path "~/.emacs.d/public_repos/ace-isearch")
(require 'ace-isearch)
(global-ace-isearch-mode 1)

;;----------------------------------------------
;; foreign-regexp.el
;;----------------------------------------------
(require 'foreign-regexp)
(custom-set-variables
 '(foreign-regexp/regexp-type 'perl)    ; perl や javascript も指定可能
 '(reb-re-syntax 'foreign-regexp))

;;=============================================
;; 8 Make Emacs More Convinient
;;=============================================
(require 'col-highlight)
;; (column-highlight-mode 1)
;; (toggle-highlight-column-when-idle 1)
;; (col-highlight-set-interval 6)

;;=================================================================
;; 9. External Program
;;=================================================================
;;----------------------------------------------
;; inheritting path from PATH for GUI emacs
;;----------------------------------------------
;; When opened from Desktep entry, PATH won't be set to shell's value.
;;http://kotatu.org/blog/2012/03/02/emacs-path-settings/
(let ((path-str
           (replace-regexp-in-string
            "\n+$" "" (shell-command-to-string "echo $PATH"))))
     (setenv "PATH" path-str)
     (setq exec-path (nconc (split-string path-str ":") exec-path)))

;;----------------------------------------------
;; Google日本語入力(Macの時)
;;----------------------------------------------
;;Google 日本語入力
(when (eq window-system 'ns)
(setq default-input-method "MacOSX")
(mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `title "あ"))

(when (eq window-system 'ns)
(set-fontset-font
 nil 'japanese-jisx0208
(font-spec :family "Hiragino Kaku Gothic ProN")))

;;----------------------------------------------
;; Multi-Term
;;----------------------------------------------
;;multi-term
(when (require 'multi-term nil t)
  (setq multi-term-program "/usr/local/bin/zsh"))

;;----------------------------------------------
;; Tramp
;;----------------------------------------------
(require 'tramp)
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))

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
(add-to-list 'exec-path "~/perl5/perlbrew/perls/perl-5.16.3/bin/")
(autoload 'edbi:open-db-viewer "edbi")
(require 'edbi)

;; working with e2wm
;; (autoload 'e2wm:dp-edbi "e2wm-edbi" nil t)
(add-to-list 'load-path "~/projects/dotfiles/.emacs.d/elpa/edbi-20140920.35")
(autoload 'e2wm:dp-edbi "e2wm-edbi" nil t)
(global-set-key (kbd "s-d") 'e2wm:dp-edbi)

;;----------------------------------------------
;; emacs ag.el
;;----------------------------------------------
;;http://rubikitch.com/2014/09/12/ag/
(setq ag-highlight-search t)

;;http://kotatu.org/blog/2013/12/18/emacs-aag-wgrep-for-code-grep-search/
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
(global-set-key (kbd "M-m") 'ag)
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


;;=============================================
;; 14 Create Documents
;;=============================================


;;----------------------
;;; howm from Otake Tomoy's  emacs Jissen Nyumon, p148
;;----------------------
(setq howm-directory (concat user-emacs-directory "howm"))

(setq howm-menu-lang 'ja)

(setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")

(when (require 'howm-mode nil t)

  (define-key global-map (kbd "C-c , ,") 'howm-menu))

(defun howm-save-buffer-and-kill ()
  (interactive)
  (when (and (buffer-file-name)
	     (string-match "\\.howm" (buffer-file-name)))
    (save-buffer)
    (kill-buffer nil)))

(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)


;;===================================================================
;; Helm
;;===================================================================

;;----------------------------------------------
;; helm.el
;;----------------------------------------------
(require 'helm-config)

(global-set-key (kbd "C-;") 'helm-for-files)
;; (define-key global-map (kbd "M-x")     'lmhelm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-c i")   'helm-imenu)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
;; (global-set-key (kbd "C-c s") 'helm-ag)
;; (global-set-key (kbd "C-c y") 'helm-show-kill-ring)

;; auto complete with TAB for find-file etc.
;; (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;; auto complete with TAB for helm-find-files etc.
;; (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

;; ; disable helm for kill-buffer
;; (add-to-list 'helm-completing-read-handlers-alist '(kill-buffer . nil))

;;----------------------------------------------
;; helm-swoop
;;----------------------------------------------
;;http://rubikitch.com/tag/package:helm-swoop/
(add-to-list 'load-path "~/.emacs.d/public_repos/helm-swoop")
(require 'helm-swoop)
;;; isearchからの連携を考えるとC-r/C-sにも割り当て推奨
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

;;----------------------------------------------
;;	isearch-dabbrev
;;----------------------------------------------
(define-key isearch-mode-map (kbd "<tab>") 'isearch-dabbrev-expand)

;;----------------------------------------------
;; imenu-anyware
;;----------------------------------------------
;;http://rubikitch.com/category/helm/
(require 'imenu)
(setq ido-enable-flex-matching t)       ;あいまいマッチ
(global-set-key (kbd "C-.") 'ido-imenu-anywhere)

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
(global-set-key (kbd "M-g M-n") 'helm-resume-and-next)
(global-set-key (kbd "M-g M-p") 'helm-resume-and-previous)

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
(setq elscreen-prefix-key (kbd "M-z"))
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
(define-key global-map (kbd "M-t") 'elscreen-next)

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
;; Working with Terminal
;;----------------------------------------------
;; (setq ns-pop-up-frames nil)


;;=================================================================
;; Multi Term
;;=================================================================
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

;;=================================================================
;; For Git
;;=================================================================




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
  (setq js-indent-level 8
        indent-tabs-mode nil
        c-basic-offset 8)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
;  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)]
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;;----------------------------------
;; Node
;;----------------------------------
;; set the path to node
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

;;----------------------------------
;; flymake
;;----------------------------------

;; set the path to jshint
(setq exec-path (append exec-path '("/usr/local/bin")))

;; flymake-jshint.el
(add-to-list 'load-path "~/.emacs.d/public_repos/flymake-jshint.el/")

(add-hook 'js2-mode-hook '(lambda ()
          (require 'flymake-jshint)
          (flymake-jshint-load)))

;; for flymake-cursor.el
(custom-set-variables
   '(help-at-pt-timer-delay 0.9)
   '(help-at-pt-display-when-idle '(flymake-overlay)))

;;----------------------
;; Tern.js
;;----------------------

;; set the path to tern
(setq exec-path (append exec-path '("/usr/local/bin")))

;; set the path to node
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

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
;; cperl-mode
;;----------------------------------------------

;; make cperl-mode as an alias to perl-mode
(defalias 'perl-mode 'cperl-mode)

;;----------------------------------------------
;; flymake
;;----------------------------------------------
;; flymake-hook
(add-hook 'cperl-modeq-hook
          (lambda ()
            (flymake-mode t)))

;;----------------------------------------------
;; perl-completion
;;----------------------------------------------
(add-to-list 'load-path "~/.emacs.d/public_repos/perl-completion/")

(defun perl-completion-hook()
  (when ( require 'perl-completion nil t)
    (perl-completion-mode t)
    (when (require 'auto-compelte nil t)
      (auto-compelte-mode t)
      (make-variable-buffer-local 'ac-sources)
      (setq ac-sources
	    '(ac-source-perl-completion)))))
(add-hook 'cperl-mode-hook 'perl-completion-hook)

;;----------------------------------------------
;; plsense
;;----------------------------------------------
;; (setq exec-path (append exec-path '("/Users/shun/perl5/perlbrew/perls/perl-5.16.3/bin/")))

;; (require 'plsense)

;; ;; キーバインド
;; (setq plsense-popup-help-key "C-:")
;; (setq plsense-display-help-buffer-key "M-:")
;; (setq plsense-jump-to-definition-key "C->")

;; ;; 必要に応じて適宜カスタマイズして下さい。以下のS式を評価することで項目についての情報が得られます。
;; ;; (customize-group "plsense")

;; ;; 推奨設定を行う
;; (plsense-config-default)


;;=============================================
;; yaml
;;=============================================
(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))



;;=============================================
;; Miscellenious 
;;=============================================

