((ace-jump-mode status "installed" recipe
		(:checksum "8351e2df4fbbeb2a4003f2fb39f46d33803f3dac" :name ace-jump-mode :after nil :website "https://github.com/winterTTr/ace-jump-mode/wiki" :description "A quick cursor location minor mode for emacs." :type github :pkgname "winterTTr/ace-jump-mode" :prepare
			   (eval-after-load "ace-jump-mode"
			     '(ace-jump-mode-enable-mark-sync))))
 (dash status "installed" recipe
       (:checksum "7cc01498a27d63ff4e0f3cd19ce7a53397fb533d" :name dash :description "A modern list api for Emacs. No 'cl required." :type github :pkgname "magnars/dash.el"))
 (el-get status "installed" recipe
	 (:checksum "ef436e5abfbf2e25171922b38f2db951c257db9d" :checksum "ef436e5abfbf2e25171922b38f2db951c257db9d" :name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
		    ("el-get.*\\.el$" "methods/")
		    :features el-get :post-init
		    (when
			(memq 'el-get
			      (bound-and-true-p package-activated-list))
		      (message "Deleting melpa bootstrap el-get")
		      (unless package--initialized
			(package-initialize t))
		      (when
			  (package-installed-p 'el-get)
			(let
			    ((feats
			      (delete-dups
			       (el-get-package-features
				(el-get-elpa-package-directory 'el-get)))))
			  (el-get-elpa-delete-package 'el-get)
			  (dolist
			      (feat feats)
			    (unload-feature feat t))))
		      (require 'el-get))))
 (el-get-lock status "installed" recipe
	      (:name el-get-lock :type github :pkgname "tarao/el-get-lock" :after nil))
 (exec-path-from-shell status "installed" recipe
		       (:checksum "c2ca275d3243e8253513ced73e3ac21dc352e303" :name exec-path-from-shell :after nil :website "https://github.com/purcell/exec-path-from-shell" :description "Emacs plugin for dynamic PATH loading" :type github :pkgname "purcell/exec-path-from-shell"))
 (helm status "installed" recipe
       (:checksum "2227344374e3113b149da84a65591ec673520777" :checksum "2227344374e3113b149da84a65591ec673520777" :name helm :after nil :features
		  ("helm-config")
		  :description "Emacs incremental completion and narrowing framework" :type github :pkgname "emacs-helm/helm" :autoloads "helm-autoloads" :build
		  (("make"))
		  :build/darwin
		  `(("make" ,(format "EMACS_COMMAND=%s" el-get-emacs)))
		  :build/windows-nt
		  (let
		      ((generated-autoload-file
			(expand-file-name "helm-autoloads.el"))
		       \
		       (backup-inhibited t))
		  (update-directory-autoloads default-directory)
		  nil)
       :post-init
       (helm-mode)))
(helm-c-yasnippet status "installed" recipe
(:checksum "2833bff9427f6d06531cf798e9152141e6b2fc83" :name helm-c-yasnippet :after nil :features
(helm-c-yasnippet)
:depends
(yasnippet helm)
:type github :pkgname "emacs-jp/helm-c-yasnippet" :description "Helm source for yasnippet.el."))
(helm-swoop status "installed" recipe
(:checksum "fd01dac3d647544f4ca297ca9963859b07ebe354" :name helm-swoop :after nil :depends
(helm)
:type github :description "Efficiently hopping squeezed lines powered by Emacs helm interface" :pkgname "ShingoFukuyama/helm-swoop"))
(hippie-exp-ext status "installed" recipe
(:name hippie-exp-ext :type elpa :after nil))
(js2-mode status "installed" recipe
(:checksum "173d1c84078afa9d0ee72d2b641354860793905f" :name js2-mode :after nil :website "https://github.com/mooz/js2-mode#readme" :description "An improved JavaScript editing mode" :type github :pkgname "mooz/js2-mode" :prepare
(autoload 'js2-mode "js2-mode" nil t)))
(package status "installed" recipe
(:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin "24" :type http :url "http://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el" :shallow nil :features package :post-init
(progn
(let
((old-package-user-dir
(expand-file-name
(convert-standard-filename
(concat
(file-name-as-directory default-directory)
"elpa")))))
(when
(file-directory-p old-package-user-dir)
(add-to-list 'package-directory-list old-package-user-dir)))
(setq package-archives
(bound-and-true-p package-archives))
(mapc
(lambda
(pa)
(add-to-list 'package-archives pa 'append))
'(("ELPA" . "http://tromey.com/elpa/")
("melpa" . "http://melpa.org/packages/")
("gnu" . "http://elpa.gnu.org/packages/")
("marmalade" . "http://marmalade-repo.org/packages/")
("SC" . "http://joseito.republika.pl/sunrise-commander/"))))))
(recentf-ext status "installed" recipe
(:checksum "495bfe07e8a759f1e6dfbd45e62ae2f72404ff79" :name recentf-ext :after nil :features
("recentf-ext")
:description "Recentf extensions" :type emacswiki))
(seqential-command status "installed" recipe
(:checksum "a88596631bb609e59d81085c37c95bc7706fd467" :name seqential-command :after nil :description "Many commands into one command" :type github :pkgname "HKey/sequential-command"))
(smartparens status "installed" recipe
(:checksum "5bef0a91540c9d447d2dcb3e6008ef9ab8644c93" :name smartparens :after nil :depends
(dash)
:description "Autoinsert pairs of defined brackets and wrap regions" :type github :pkgname "Fuco1/smartparens"))
(window-numbering status "installed" recipe
(:checksum "575ad203545b01e21d28fefc0d8b809d1016ea3a" :name window-numbering :after nil :website "http://nschum.de/src/emacs/window-numbering-mode/" :description "Assigns numbers to Emacs windows to allow easy window navigation." :type github :pkgname "nschum/window-numbering.el"))
(yasnippet status "installed" recipe
(:checksum "e9406f51266f9b9179f475886fa4ec78f1ccba44" :checksum "e9406f51266f9b9179f475886fa4ec78f1ccba44" :name yasnippet :website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :compile "yasnippet.el" :submodule nil :build
(("git" "submodule" "update" "--init" "--" "snippets")))))
