;;; -*- lexical-binding: t; -*-
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))

(defvar non-repo-lisp-packages-path (concat user-emacs-directory "lisp/"))

(require 'package)

(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Add local path to Emacs packages not managed by one of the repos above
(add-to-list 'load-path non-repo-lisp-packages-path)
(add-to-list 'load-path (concat non-repo-lisp-packages-path "assist_emacs")) ;; my own package

(use-package no-littering)

(use-package savehist
  :config
  (add-to-list 'savehist-additional-variables 'eww-history)
  (savehist-mode))

(setq tab-bar-new-tab-choice "*dashboard*")

(toggle-frame-fullscreen)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tooltip-mode 0)
(display-time-mode 1)
(set-fringe-mode 5)

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq visible-bell t)

;;(use-package doom-themes
;;:init (load-theme 'doom-outrun-electric t))

;;(use-package zenburn-theme
;;  :config
;;  (load-theme 'zenburn t))

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-hard t))

(set-face-attribute 'default nil :font "Fira Code Retina" :height 120)
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 120)
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 140 :weight 'regular)

(column-number-mode 1)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook
		pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package dashboard
  :config
  (setq dashboard-banner-logo-title "Welcome")
  (setq dashboard-startup-banner "~/.emacs.d/logos/emax.png")
  (setq dashboard-center-content t)
  (setq dashboard-vertical-center-content t)
  (setq dashboard-items '((recents . 5)
			  (bookmarks . 5)
			  (projects . 5)
			  (agenda . 5)
			  (registers . 5)))
  (setq dashboard-navigation-cycle t)
  (setq dashboard-item-shortcuts '((recents   . "r")
                                   (bookmarks . "m")
                                   (projects  . "p")
                                   (agenda    . "a")
                                   (registers . "e")))
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (dashboard-setup-startup-hook))

(use-package dired
  :ensure nil)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "M-o") 'other-window)

(use-package general
  :config
  (general-create-definer max/leader-keys
    :keymaps 'override
    :prefix "C-q")

  (max/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "c" '(org-capture :which-key "capture template")))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(max/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(setq display-buffer-alist '(("\\`\\*e?shell" display-buffer-pop-up-window)
                             ("\\`\\*shell" display-buffer-pop-up-window)
                             ("\\`\\*term" display-buffer-pop-up-window)))

(with-eval-after-load 'ispell
   (remove-hook 'completion-at-point-functions
                #'ispell-completion-at-point))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 7)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (setq ivy-use-selectable-prompt t
        ivy-extra-directories nil
	ivy-use-history t)
  (ivy-mode 1))

(use-package ivy-prescient
  :after ivy
  :config
  (ivy-prescient-mode 1)
  (prescient-persist-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq counsel-find-file-ignore-regexp
      (rx (or (seq string-start "#" (* any) "#" string-end)
              (seq (* any) "~" string-end)
              (seq (* any) ".swp" string-end)
              (seq (* any) ".tmp" string-end)))))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defun max/org-remove-ispell-capf ()
(setq-local completion-at-point-functions
            (remove #'ispell-completion-at-point
                    completion-at-point-functions)))

(defun max/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (max/org-remove-ispell-capf))

(use-package org
  :hook (org-mode . max/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-agenda-start-with-log-mode t
	org-log-done 'time
	org-log-into-drawer t
	org-hide-emphasis-markers t
	org-startup-folded t
	org-hide-drawer-startup t
	org-agenda-files
	'("~/Nextcloud/Documents/org-files/tasks.org"
	  "~/Nextcloud/Documents/org-files/habits.org"))
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)
  :custom
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))
  (setq org-preview-latex-default-process 'dvisvgm))
;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode))

;; (font-lock-add-keywords 'org-mode
;; 			'(("^ *\\([-]\\) "
;; 			  (0 (prog1 () (compose-region (match-beginning 1)(match-end 1) "•"))))))

(with-eval-after-load 'org-faces (dolist (face '((org-level-1 . 1.2)
	        (org-level-2 . 1.1)
		(org-level-3 . 1.05)
		(org-level-4 . 1.0)
		(org-level-5 . 1.1)
		(org-level-6 . 1.1)
		(org-level-7 . 1.1)
		(org-level-8 . 1.1)))
	      (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-hide nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil :inherit 'fixed-pitch))

(defun max/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . max/org-mode-visual-fill))

(remove-hook 'completion-at-point-functions
           #'ispell-completion-at-point)

(use-package org-modern
  :hook (org-mode . org-modern-mode))

(setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))


(require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

;; Configure custom agenda views
(setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
v     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

(defvar my-org-language-directory
  "~/Nextcloud/Documents/org-files/languages/")

(defvar my-org-last-language nil)

(defun my-org-language-files ()
  (mapcar
    (lambda (file)
    (file-name-base file))
  (directory-files
    (expand-file-name my-org-language-directory)
    t
    "\\.org\\'")))

(defun my-org-select-language ()
  (let* ((langs (my-org-language-files))
       (default (or my-org-last-language
                    (car langs)))
       (choice
        (completing-read
         "Language: "
         langs
         nil
         t
         nil
         nil
         default)))
  (setq my-org-last-language choice)
    choice))

(defun my-org-capture-anki-basic ()
  (let* ((lang (my-org-select-language))
         (file (expand-file-name
                (concat lang ".org")
                my-org-language-directory)))
    (org-capture-set-target-location
     `(file+headline ,file "Basics"))))

(setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/Nextcloud/Documents/org-files/tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/Nextcloud/Documents/org-files/journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/Nextcloud/Documents/org-files/journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("v" "Vocabulary")
      ("vb" "Basic" entry (function my-org-capture-anki-basic)
	 "* %^{Front}\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:END:\n\n%^{Back}\n\n")
      
      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/Nextcloud/Documents/org-files/journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/Nextcloud/Documents/org-files/metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)
      ("e" "EWW article"
           entry
           (file "~/Nextcloud/Documents/org-files/web.org")
           "* %a\n:PROPERTIES:\n:URL: %u\n:END:\n\n%?"
           :empty-lines 1)))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("rs" . "src rust"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (mermaid t)))

(defun max/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
		      (expand-file-name "~/Documents/Projects/dotfiles/.emacs.d/config.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'max/org-babel-tangle-config)))

(use-package ob-mermaid
  :config
  (setq ob-mermaid-default-config-file "~/.config/mermaid/mermaid-config.js"))

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil))

(defun org-roam-gaph--view (file)
  (find-file file))

(use-package org-roam
  :custom
  (org-roam-directory "~/Nextcloud/Documents/org-files/roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point))
  :config
  (setq org-roam-completion-everywhere t)
  (setq org-roam-graph-viewer #'org-roam-graph--view)
  (org-roam-db-autosync-mode))

(use-package websocket
    :after org-roam)

(use-package org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(require 'org-eww)

(use-package org-fragtog
  :hook (org-mode-hook . org-fragtog-mode))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t)
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  ;; enable / disable the hints as you prefer:
  (lsp-inlay-hint-enable t)
  ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(max/leader-keys
  "d" '(lsp-ui-doc-show :which-key "show symbol doc"))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
	  ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
	  ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  (company-backends '(company-capf company-files company-keywords)))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Documents/Projects")
    (setq projectile-project-search-path '("~/Documents/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(setq magit-ediff-dwim-show-on-hunks t)
(custom-set-variables '(ediff-split-window-function (quote split-window-horizontally)))

(use-package elisp-mode
  :ensure nil
  :hook ((emacs-lisp-mode . flymake-mode)
         (emacs-lisp-mode . eldoc-mode)))

(use-package python-mode
  :hook (python-mode . lsp-deferred)
  :config
  (setq python-shell-interpreter "python3"))

(use-package rustic
:ensure
:bind (:map rustic-mode-map
            ("M-j" . lsp-ui-imenu)
            ("M-?" . lsp-find-references)
            ("C-c C-c l" . flycheck-list-errors)
            ("C-c C-c a" . lsp-execute-code-action)
            ("C-c C-c r" . lsp-rename)
            ("C-c C-c q" . lsp-workspace-restart)
            ("C-c C-c Q" . lsp-workspace-shutdown)
            ("C-c C-c s" . lsp-rust-analyzer-status))
:config
;; uncomment for less flashiness
;; (setq lsp-eldoc-hook nil)
;; (setq lsp-enable-symbol-highlighting nil)
;; (setq lsp-signature-auto-activate nil)

;; comment to disable rustfmt on save
(setq rustic-format-on-save t))

(use-package sh-script
  :hook (sh-mode . lsp-deferred))

;; Use a custom file so that emacs doesn't write in init.el
(setq custom-file "~/.config/emacs/.emacs.custom")
(load-file custom-file)

(setq org-refile-targets
    '(("archive.org" :maxlevel . 1)
      ("tasks.org" :maxlevel . 1)))

(use-package term
  :config
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-max-scrollback 10000))

(use-package pdf-tools
  :init
  (pdf-tools-install)
  :hook
  (pdf-view-mode . pdf-view-roll-minor-mode))

(use-package pdf-view-restore
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode)
  (setq pdf-view-restore-filename (concat user-emacs-directory ".pdf-view-restore")))

(use-package anki-editor)

(use-package ebdb
  :ensure t
  :defer t
  :init
  (setq ebdb-sources '("~/Nextcloud/emacs/edbd"))
  (setq ebdb-complete-mail t
        ebdb-complete-name t)
  :config
  (setq ebdb-default-window-size 0.3
        ebdb-multiline t)
  (setq ebdb-auto-save-p t)
  (require 'edbd-vcard))

(use-package company-ebdb
  :ensure t
  :after (ebdb company)
  :config
  (add-to-list 'company-backends 'company-ebdb))

(use-package ivy-prescient
  :after ivy
  :config
  (ivy-prescient-mode 1))

(use-package eww
  :commands (eww eww-open-file)
  :init
  (setq eww-search-prefix "https://www.duckduckgo.com/search?q="
        eww-download-directory "~/downloads"
        shr-color-visible-luminance-min 80)

  :config

  ;; ----------------------------
  ;; Search at point / region
  ;; ----------------------------
  (defun max/eww-search-at-point ()
    "Search region or symbol at point."
    (interactive)
    (let ((query
           (cond
            ((use-region-p)
             (buffer-substring-no-properties
              (region-beginning) (region-end)))
            ((thing-at-point 'symbol t))
            (t nil))))
      (if (and query (not (string-blank-p query)))
          (eww query)
        (call-interactively #'eww))))

  ;; ----------------------------
  ;; Force new buffer with C-u
  ;; ----------------------------
  (defun max/eww-new-buffer-advice (orig &rest args)
    (if current-prefix-arg
        (with-temp-buffer (apply orig args))
      (apply orig args)))
  (advice-add 'eww :around #'max/eww-new-buffer-advice)

  ;; ----------------------------
  ;; Auto rename buffers
  ;; ----------------------------
  (add-hook 'eww-mode-hook
            (lambda ()
              (rename-buffer "eww" t)))

  ;; ----------------------------
  ;; Copy URL (simple + reliable)
  ;; ----------------------------
  (defun max/eww-copy-url ()
    "Copy link at point or page URL."
    (interactive)
    (let ((url (or (get-text-property (point) 'shr-url)
                   (eww-current-url))))
      (when url
        (kill-new url)
        (message "Copied: %s" url))))

  ;; ----------------------------
  ;; Toggle images
  ;; ----------------------------
  (defun max/eww-toggle-images ()
    (interactive)
    (setq-local shr-inhibit-images (not shr-inhibit-images))
    (eww-reload)
    (message "Images %s"
             (if shr-inhibit-images "disabled" "enabled")))

  ;; ----------------------------
  ;; Browse current file in EWW
  ;; ----------------------------
  (defun max/eww-browse-file ()
    (interactive)
    (let ((browse-url-browser-function #'eww-browse-url))
      (call-interactively #'browse-url-of-file)))

  ;; ----------------------------
  ;; Core keybindings
  ;; ----------------------------
  (define-key eww-mode-map (kbd "s") #'max/eww-search-at-point)
  (define-key eww-mode-map (kbd "w") #'max/eww-copy-url)
  (define-key eww-mode-map (kbd "I") #'max/eww-toggle-images)
  (define-key eww-mode-map (kbd "h") #'eww-list-histories)
  (define-key eww-mode-map (kbd ":") #'eww)

  ;; Reload
  (define-key eww-mode-map [remap revert-buffer] #'eww-reload)

  ;; Navigation
  (define-key eww-mode-map (kbd "TAB") #'shr-next-link)
  (define-key eww-mode-map (kbd "<backtab>") #'shr-previous-link)
)

  ;; Default eww key bindings
  ;; |-----------+---------------------------------------------------------------------|
  ;; | Key       | Function                                                            |
  ;; |-----------+---------------------------------------------------------------------|
  ;; | &         | Browse the current URL with an external browser.                    |
  ;; | -         | Begin a negative numeric argument for the next command.             |
  ;; | 0 .. 9    | Part of the numeric argument for the next command.                  |
  ;; | C         | Display a buffer listing the current URL cookies, if there are any. |
  ;; | H         | List the eww-histories.                                             |
  ;; | F         | Toggle font between variable-width and fixed-width.                 |
  ;; | G         | Go to a URL                                                         |
  ;; | R         | Readable mode                                                       |
  ;; | S         | List eww buffers                                                    |
  ;; | d         | Download URL under point to `eww-download-directory'.               |
  ;; | g         | Reload the current page.                                            |
  ;; | q         | Quit WINDOW and bury its buffer.                                    |
  ;; | v         | `eww-view-source'                                                   |
  ;; | w         | `eww-copy-page-url'                                                 |
  ;; |-----------+---------------------------------------------------------------------|
  ;; | b         | Add the current page to the bookmarks.                              |
  ;; | B         | Display the bookmark list.                                          |
  ;; | M-n       | Visit the next bookmark                                             |
  ;; | M-p       | Visit the previous bookmark                                         |
  ;; |-----------+---------------------------------------------------------------------|
  ;; | t         | Go to the page marked `top'.                                        |
  ;; | u         | Go to the page marked `up'.                                         |
  ;; |-----------+---------------------------------------------------------------------|
  ;; | n         | Go to the page marked `next'.                                       |
  ;; | p         | Go to the page marked `previous'.                                   |
  ;; |-----------+---------------------------------------------------------------------|
  ;; | l         | Go to the previously displayed page.                                |
  ;; | r         | Go to the next displayed page.                                      |
  ;; |-----------+---------------------------------------------------------------------|
  ;; | TAB       | Move point to next link on the page.                                |
  ;; | S-TAB     | Move point to previous link on the page.                            |
  ;; |-----------+---------------------------------------------------------------------|
  ;; | SPC       | Scroll up                                                           |
  ;; | DEL/Bkspc | Scroll down                                                         |
  ;; | S-SPC     | Scroll down                                                         |
  ;; |-----------+---------------------------------------------------------------------|

(use-package eww-lnum
  :after eww
  :bind (:map eww-mode-map
              ("f" . eww-lnum-follow)
              ("F" . eww-lnum-universal)))

(use-package password-store)

(use-package pass
  :after password-store
  :commands (pass))

(use-package mu4e
  :ensure nil
  :load-path "~/mu/mu4e/"
  :config
  (setq mail-user-agent 'mu4e)

  (setq mu4e-mu-binary "~/mu/build/mu/mu")
  (setq mu4e-change-filenames-when-moving t)

  (setq mu4e-update-interval (* 3 60))     ;; Update every 3 minutes
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-index-lazy-check t)
  (setq mu4e-maildir "~/Mail")
  
  (setq mu4e-drafts-folder "/gmx/Drafts")
  (setq mu4e-sent-folder "/gmx/Sent")
  (setq mu4e-refile-folder "/gmx/Archiv")
  (setq mu4e-trash-folder "/gmx/Trash")

  (setq mu4e-maildir-shortcuts
	'(("/gmx/INBOX"   . ?i)
	  ("/gmx/Sent"    . ?s)
	  ("/gmx/Trash"   . ?t)
	  ("/gmx/Drafts"  . ?d)
	  ("/gmx/Archive" . ?a)))

  (setq mu4e-use-fancy-chars t)

  :hook
  ;; tweak the composer
  ((mu4e-compose-mode . (lambda ()
                          (set-fill-column 72)
                          (flyspell-mode)))
   ;; allow for inserting attachments with dired,
   ;;   with `M-x gnus-dired-attach'
   (dired-mode  . turn-on-gnus-dired-mode))

  :bind ;; the Mu4e transient menu
  (("C-c m" . mu4e)))



;;  (require 'kg)

;;  (setq kg-backend-url "http://localhost:3000")

;;  (setq kg-auto-process nil)

;;  (kg-initialize)
