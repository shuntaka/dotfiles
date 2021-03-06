((ace-jump-mode status "installed" recipe
                (:checksum "8351e2df4fbbeb2a4003f2fb39f46d33803f3dac" :name ace-jump-mode :after nil :website "https://github.com/winterTTr/ace-jump-mode/wiki" :description "A quick cursor location minor mode for emacs." :type github :pkgname "winterTTr/ace-jump-mode" :prepare
                           (eval-after-load "ace-jump-mode"
                             '(ace-jump-mode-enable-mark-sync))))
 (cl-lib status "installed" recipe
         (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :url "http://elpa.gnu.org/packages/cl-lib.html"))
 (dash status "installed" recipe
       (:checksum "7cc01498a27d63ff4e0f3cd19ce7a53397fb533d" :name dash :description "A modern list api for Emacs. No 'cl required." :type github :pkgname "magnars/dash.el"))
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
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
 (epl status "required" recipe
      (:name epl :description "EPL provides a convenient high-level API for various package.el versions, and aims to overcome its most striking idiocies." :type github :pkgname "cask/epl"))
 (exec-path-from-shell status "installed" recipe
                       (:checksum "c2ca275d3243e8253513ced73e3ac21dc352e303" :name exec-path-from-shell :after nil :website "https://github.com/purcell/exec-path-from-shell" :description "Emacs plugin for dynamic PATH loading" :type github :pkgname "purcell/exec-path-from-shell"))
 (flycheck status "required" recipe
           (:name flycheck :after nil :depends
                  (seq let-alist pkg-info dash)
                  :type github :pkgname "flycheck/flycheck" :minimum-emacs-version "24.3" :description "On-the-fly syntax checking extension"))
 (helm status "installed" recipe
       (:checksum "6085777884bf8cc63a6e15cbbb506d09d782f0cc" :name helm :after nil :features
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
(:checksum "002338d9685d82ef10aaf97d2e8084e61dfc94b4" :name helm-swoop :after nil :depends
(helm)
:type github :description "Efficiently hopping squeezed lines powered by Emacs helm interface" :pkgname "ShingoFukuyama/helm-swoop"))
(highlight-indentation status "installed" recipe
(:checksum "cd6d8168ccb04c6c0394f42e9512c58f23c01689" :name highlight-indentation :after nil :description "Function for highlighting indentation" :type git :url "https://github.com/antonj/Highlight-Indentation-for-Emacs"))
(hippie-exp-ext status "installed" recipe
(:name hippie-exp-ext :type elpa :after nil))
(indent-guide status "installed" recipe
(:name indent-guide :after nil :description "show vertical lines to guide indentation." :website "https://github.com/zk-phi/indent-guide" :type github :pkgname "zk-phi/indent-guide" :checksum "feb207cb5610f351c7cdcf266e0c99117b2f786c"))
(js2-mode status "installed" recipe
(:checksum "173d1c84078afa9d0ee72d2b641354860793905f" :name js2-mode :after nil :website "https://github.com/mooz/js2-mode#readme" :description "An improved JavaScript editing mode" :type github :pkgname "mooz/js2-mode" :prepare
(autoload 'js2-mode "js2-mode" nil t)))
(let-alist status "required" recipe
(:name let-alist :description "Easily let-bind values of an assoc-list by their names." :builtin "25.0.50" :type elpa :url "https://elpa.gnu.org/packages/let-alist.html"))
(package status "installed" recipe
(:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin "24" :type http :url "https://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el" :features package :post-init
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
(let
((protocol
(if
(and
(fboundp 'gnutls-available-p)
(gnutls-available-p))
"https://"
(lwarn
'(el-get tls)
:warning "Your Emacs doesn't support HTTPS (TLS)%s"
(if
(eq system-type 'windows-nt)
",\n  see https://github.com/dimitri/el-get/wiki/Installation-on-Windows." "."))
"http://"))
(archives
'(("melpa" . "melpa.org/packages/")
("gnu" . "elpa.gnu.org/packages/")
("marmalade" . "marmalade-repo.org/packages/"))))
(dolist
(archive archives)
(add-to-list 'package-archives
(cons
(car archive)
(concat protocol
(cdr archive)))))))))
(pkg-info status "required" recipe
(:name pkg-info :description "Provide information about Emacs packages." :type github :pkgname "lunaryorn/pkg-info.el" :depends
(dash epl)))
(recentf-ext status "installed" recipe
(:checksum "495bfe07e8a759f1e6dfbd45e62ae2f72404ff79" :name recentf-ext :after nil :features
("recentf-ext")
:description "Recentf extensions" :type emacswiki))
(seq status "required" recipe
(:name seq :description "Sequence manipulation library for Emacs" :builtin "25" :type github :pkgname "NicolasPetton/seq.el"))
(seqential-command status "installed" recipe
(:checksum "a88596631bb609e59d81085c37c95bc7706fd467" :name seqential-command :after nil :description "Many commands into one command" :type github :pkgname "HKey/sequential-command"))
(smartparens status "installed" recipe
(:checksum "5bef0a91540c9d447d2dcb3e6008ef9ab8644c93" :name smartparens :after nil :depends
(dash)
:description "Autoinsert pairs of defined brackets and wrap regions" :type github :pkgname "Fuco1/smartparens"))
(visual-regexp status "installed" recipe
(:checksum "b625cec147dd1ac185aac52e2ae27acb2a662b28" :name visual-regexp :description "A regexp/replace command for Emacs with\n       interactive visual feedback" :type github :depends cl-lib :pkgname "benma/visual-regexp.el"))
(visual-regexp-steroids status "installed" recipe
(:checksum "b724d2a30efbcf2a13f6c34b798aeb453ff076be" :name visual-regexp-steroids :after nil :depends
(visual-regexp)
:description "An extension to visual-regexp-steroids which enables\nthe use of modern regexp engines" :type github :pkgname "benma/visual-regexp-steroids.el"))
(window-numbering status "installed" recipe
(:checksum "575ad203545b01e21d28fefc0d8b809d1016ea3a" :name window-numbering :after nil :website "http://nschum.de/src/emacs/window-numbering-mode/" :description "Assigns numbers to Emacs windows to allow easy window navigation." :type github :pkgname "nschum/window-numbering.el"))
(yasnippet status "installed" recipe
(:checksum "e9406f51266f9b9179f475886fa4ec78f1ccba44" :name yasnippet :website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :compile "yasnippet.el" :submodule nil :build
(("git" "submodule" "update" "--init" "--" "snippets")))))
