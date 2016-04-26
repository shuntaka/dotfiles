((ace-jump-mode status "installed" recipe
                (:name ace-jump-mode :after nil :website "https://github.com/winterTTr/ace-jump-mode/wiki" :description "A quick cursor location minor mode for emacs." :type github :pkgname "winterTTr/ace-jump-mode" :prepare
                       (eval-after-load "ace-jump-mode"
                         '(ace-jump-mode-enable-mark-sync))))
 (cl-lib status "installed" recipe
         (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :url "http://elpa.gnu.org/packages/cl-lib.html"))
 (dash status "installed" recipe
       (:name dash :description "A modern list api for Emacs. No 'cl required." :type github :pkgname "magnars/dash.el"))
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
 (exec-path-from-shell status "installed" recipe
                       (:name exec-path-from-shell :after nil :website "https://github.com/purcell/exec-path-from-shell" :description "Emacs plugin for dynamic PATH loading" :type github :pkgname "purcell/exec-path-from-shell"))
 (fuzzy status "installed" recipe
        (:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (helm status "installed" recipe
       (:name helm :after nil :features
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
(:name helm-c-yasnippet :after nil :features
(helm-c-yasnippet)
:type github :pkgname "emacs-jp/helm-c-yasnippet" :description "Helm source for yasnippet.el." :depends
(helm yasnippet)))
(helm-swoop status "installed" recipe
(:name helm-swoop :after nil :type github :description "Efficiently hopping squeezed lines powered by Emacs helm interface" :pkgname "ShingoFukuyama/helm-swoop" :depends
(helm)))
(hippie-exp-ext status "installed" recipe
(:name hippie-exp-ext :after nil :auto-generated t :type emacswiki :description "Extension of hippie-expand" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/hippie-exp-ext.el"))
(js2-mode status "installed" recipe
(:name js2-mode :after nil :website "https://github.com/mooz/js2-mode#readme" :description "An improved JavaScript editing mode" :type github :pkgname "mooz/js2-mode" :prepare
(autoload 'js2-mode "js2-mode" nil t)))
(popup status "installed" recipe
(:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :submodule nil :depends cl-lib :pkgname "auto-complete/popup-el"))
(recentf-ext status "installed" recipe
(:name recentf-ext :after nil :features
("recentf-ext")
:description "Recentf extensions" :type emacswiki))
(seqential-command status "installed" recipe
(:name seqential-command :after nil :description "Many commands into one command" :type github :pkgname "HKey/sequential-command"))
(smartparens status "installed" recipe
(:name smartparens :after nil :description "Autoinsert pairs of defined brackets and wrap regions" :type github :pkgname "Fuco1/smartparens" :depends dash))
(sqlplus status "installed" recipe
(:name sqlplus :after nil :auto-generated t :type emacswiki :description "User friendly interface to SQL*Plus and support for PL/SQL compilation" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/sqlplus.el"))
(window-numbering status "installed" recipe
(:name window-numbering :after nil :website "http://nschum.de/src/emacs/window-numbering-mode/" :description "Assigns numbers to Emacs windows to allow easy window navigation." :type github :pkgname "nschum/window-numbering.el"))
(yasnippet status "installed" recipe
(:name yasnippet :website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :compile "yasnippet.el" :submodule nil :build
(("git" "submodule" "update" "--init" "--" "snippets")))))
