;;; -*- lexical-binding: t; -*-
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))

(defvar my-config-file "~/Documents/Projects/dotfiles/.emacs.d/config.org")
(defvar my-config-directory "~/.config/")
(defvar my-emacs-logo-directory (concat user-emacs-directory "logos/"))
(defvar my-local-packages-directory (concat user-emacs-directory "lisp/"))
(defvar my-org-directory "~/Nextcloud/Documents/org-files/")
(defvar my-org-language-directory "~/Nextcloud/Documents/org-files/languages/")
(defvar my-projects-directory "~/Documents/Projects/")
(defvar my-downloads-directory "~/Downloads/")
(defvar my-mail-directory "~/Mail")
(defvar my-mu4e-load-directory "~/mu/mu4e/")
(defvar my-mu-binary "~/mu/build/mu/mu")
(defvar my-edbd-directory "~/Nextcloud/emacs/edbd")

(require 'package)

(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))

(package-initialize)
(unless (or package-archive-contents (file-exists-p package-user-dir))
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Add local path to Emacs packages not managed by one of the repos above
(add-to-list 'load-path my-local-packages-directory)
(add-to-list 'load-path (concat my-local-packages-directory "assist_emacs")) ;; my own package

(use-package no-littering)

(use-package savehist
  :config
  (add-to-list 'savehist-additional-variables 'eww-history)
  (savehist-mode))

(setq tab-bar-new-tab-choice "*dashboard*")

;; Don't toggle fullscreen when running in terminal
(add-hook 'after-init-hook
	  (lambda ()
	    (when (display-graphic-p)
	      (toggle-frame-fullscreen))))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tooltip-mode 0)
(display-time-mode 1)
(set-fringe-mode 5)
(setq left-fringe-width 16)

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq visible-bell t)

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-hard t))

(set-face-attribute 'default nil
		    :font "Fira Code Retina"
		    :height 120)

(set-face-attribute 'fixed-pitch nil
		    :font "Fira Code Retina"
		    :height 120)

(set-face-attribute 'variable-pitch nil
		    :font "Cantarell"
		    :height 140
		    :weight 'regular)

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
  :custom
  (dashboard-footer-messages
    '("Hey! Listen! Your parentheses don't match."
      "The minibuffer holds many secrets."
      "The next quest begins after C-x C-s."
      "It's dangerous to edit alone. Take this manual."
      "The Master Sword cannot fix an unbalanced expression."
      "Wisdom is knowing when to press C-g."
      "Courage is evaluating the buffer anyway."
      "Power is knowing how to undo it afterward."
      "The Triforce of Emacs: C-g, C-x C-s, and M-x."
      "Every great adventure begins with M-x."
      "A new buffer is an unexplored kingdom."
      "Somewhere in this buffer, a parenthesis is missing."
      "The dungeon boss is probably in your init file."
      "Your quest log is called *Messages*."
      "The minibuffer awaits your command."
      "Consult the ancient scrolls: C-h i."
      "The wise hero reads the docstring."
      "The courageous hero reads the source."
      "The reckless hero evaluates it immediately."
      "May your buffers be many and your errors few."
      "May your parentheses always return home."
      "May your packages compile without warning."
      "May your kill ring never forget."
      "The kingdom can wait. Your init file needs debugging."
      "A hidden command lies behind every M-x."
      "Not all who wander through buffers are lost."
      "Some are looking for the definition."
      "Follow the mode line. It knows the way."
      "The mode line has been trying to tell you something."
      "When the path is unclear, press C-h."
      "When all hope is lost, press C-g."
      "When even C-g fails, there is always ESC ESC ESC."
      "The Great Fairy of Completion knows what you meant."
      "Completion is the fairy companion of the minibuffer."
      "The minibuffer whispers: type a little more."
      "A mysterious command has appeared in your completion list."
      "Choose your command wisely."
      "You obtained a new major mode!"
      "You obtained a new key binding!"
      "You obtained a package! Your config grows heavier."
      "You found a hidden buffer!"
      "You found the scratch buffer. It was here all along."
      "You discovered an ancient Lisp expression."
      "This expression looks important. Evaluate it?"
      "A strange symbol is glowing in your init file."
      "That variable looks suspicious."
      "That hook looks suspicious."
      "That advice looks extremely suspicious."
      "There is probably a hook for that."
      "There is definitely a variable for that."
      "There might even be a command for that."
      "Before writing a function, try M-x apropos-command."
      "Before adding a package, consult the ancient manuals."
      "Before blaming Emacs, check your init file."
      "Before blaming your init file, start with emacs -Q."
      "The path to enlightenment begins with emacs -Q."
      "A clean Emacs reveals many truths."
      "The bug disappears under emacs -Q. The quest continues."
      "The bug remains under emacs -Q. A worthy opponent."
      "A stack trace has appeared!"
      "The backtrace contains the map to the dungeon."
      "Every error message is a clue."
      "Every warning is a side quest."
      "Every deprecation warning foretells a future adventure."
      "The debugger opens. Battle music begins."
      "Enter the debugger with courage."
      "Step through the code like a hero through a dungeon."
      "The final boss was an extra parenthesis."
      "The final boss was a missing parenthesis."
      "The final boss was lexical scope."
      "The final boss was a stale byte-compiled file."
      "The final boss was your load-path."
      "The true enemy was configuration all along."
      "Your init file has entered its second phase."
      "This configuration has too many phases."
      "A new package awakens."
      "The package was loaded. Nothing visibly changed."
      "A mysterious minor mode is now active."
      "You have activated something. Probably."
      "Check the mode line before proceeding."
      "The mode line reveals your current equipment."
      "Major modes determine the terrain."
      "Minor modes provide the enchanted items."
      "Hooks are where adventures begin automatically."
      "Advice is powerful magic. Use it carefully."
      "Macros are ancient magic. Read them twice."
      "Lisp is the language of the sages."
      "The parentheses are not decoration."
      "The parentheses show you the path."
      "Indentation reveals the shape of the dungeon."
      "When indentation looks wrong, trust your instincts."
      "Indent the region. Let the truth be revealed."
      "Paredit protects the sacred structure."
      "Structural editing is the hookshot of Lisp."
      "A balanced expression is a peaceful expression."
      "The sexp knows where it begins and ends."
      "Move by sexps, not by footsteps."
      "Your cursor is the hero of this story."
      "Point marks where the hero stands."
      "Mark remembers where the hero has been."
      "The region is your current quest area."
      "Narrowing seals off the rest of the kingdom."
      "Widen when you are ready to return to the overworld."
      "The buffer is larger on the inside."
      "Windows are not frames. The sages insist."
      "Frames are not windows. The sages insist even louder."
      "Split the window to reveal another chamber."
      "C-x 1 seals the other chambers."
      "C-x 2 opens a passage below."
      "C-x 3 opens a passage to the side."
      "Other-window leads to the neighboring chamber."
      "Buried buffers still dream of being displayed."
      "The buffer list is your inventory screen."
      "Too many buffers? A true hero carries everything."
      "The kill ring remembers fallen text."
      "Yank what was lost."
      "Yank-pop until the ancient text returns."
      "Undo bends the flow of time."
      "Undo again. The timeline changes."
      "Redo restores the forgotten timeline."
      "Version control is the Ocarina of Time for source code."
      "Git remembers worlds that no longer exist."
      "Magit opens the map of altered timelines."
      "A dirty working tree blocks the path forward."
      "Commit your progress before entering the next dungeon."
      "A clean working tree brings peace to Hyrule."
      "The diff reveals what changed while you were away."
      "A merge conflict has appeared."
      "Two timelines have collided."
      "Resolve the conflict and restore the proper timeline."
      "The repository has been saved."
      "Your branch has diverged. Choose a path."
      "Do not force-push without the Triforce of Wisdom."
      "The remote kingdom has new commits."
      "Fetch news from distant lands."
      "The ancient repository still builds."
      "The ancient repository no longer builds."
      "Another dependency has awakened."
      "Your load-path stretches across the kingdom."
      "Somewhere in ~/.emacs.d, an old spell still runs."
      "Somewhere in your config, a forgotten setq waits."
      "The answer is probably in custom.el."
      "Custom has written upon the sacred file."
      "A variable has been set twice. Which timeline is real?"
      "Your keymap contains a hidden passage."
      "That key is already bound."
      "A command sleeps beneath this key sequence."
      "C-h k reveals the power of the key."
      "C-h f reveals the lore of the command."
      "C-h v reveals the lore of the variable."
      "C-h m reveals the laws of this realm."
      "C-h b reveals your available techniques."
      "Describe-mode before entering unfamiliar territory."
      "Apropos searches the kingdom by name."
      "Occur marks every place where the monster appears."
      "Isearch follows the trail."
      "Search forward. The answer is near."
      "Search backward. You may have passed it."
      "Query-replace offers a dangerous bargain."
      "Replace all? Choose wisely."
      "Regexp is an ancient and temperamental magic."
      "Your regexp almost works. The dungeon laughs."
      "One escaped backslash separates triumph from despair."
      "The syntax table knows things you do not."
      "Font lock paints the walls of the dungeon."
      "Treesitter sees the structure beneath the surface."
      "LSP brings messages from distant language servers."
      "The language server has something to say."
      "The language server has far too much to say."
      "A diagnostic marker hovers nearby."
      "The compiler foretells trouble."
      "Compilation mode remembers where the monsters live."
      "Press next-error and continue the hunt."
      "One error remains."
      "No errors remain. The kingdom is at peace."
      "Warnings remain. The kingdom is mostly at peace."
      "The tests pass. A heart container appears."
      "One test fails. The boss has another phase."
      "Run the tests again. Perhaps the timeline changed."
      "A flaky test is a cursed artifact."
      "The build succeeds. The gates open."
      "The build fails. Consult *compilation*."
      "Your REPL is a portal to another realm."
      "Evaluate the expression and observe the omen."
      "The scratch buffer fears no consequence."
      "*scratch* is where experimental magic belongs."
      "A wise wizard tests the spell in *scratch* first."
      "The echo area carries messages from afar."
      "The echo area has spoken."
      "The echo area saw what you did."
      "The *Messages* buffer remembers everything."
      "Nothing truly disappears from *Messages*."
      "Your command history remembers the old paths."
      "Repeat the spell with M-p."
      "The minibuffer remembers your previous quests."
      "Save your work before summoning package-upgrade."
      "Package upgrades can awaken ancient evils."
      "Read the NEWS file before challenging the new version."
      "Your config survived the upgrade."
      "Your config did not survive the upgrade."
      "A deprecated function blocks the bridge."
      "The manual contains a forgotten solution."
      "Info nodes form an ancient labyrinth."
      "Follow the cross-reference."
      "Another Info node lies beyond."
      "The manual was right."
      "The manual is usually right."
      "Documentation is the map; source code is the terrain."
      "When documentation ends, source code begins."
      "Find-function opens the secret passage."
      "Find-variable reveals where the artifact was forged."
      "The source is only one keypress away."
      "Read the Lisp. Become the sage."
      "Modify the Lisp. Become the hero."
      "Evaluate the Lisp. Accept the consequences."
      "Your configuration is your personal Hyrule."
      "Every package adds another province."
      "Every key binding opens another shortcut."
      "Every custom function is a secret technique."
      "Every saved macro is an enchanted item."
      "Every buffer is another room in the dungeon."
      "Every project is another kingdom to save."
      "Your TODO list contains many side quests."
      "Org mode keeps the hero's journal."
      "A TODO has awakened."
      "The agenda reveals today's quests."
      "A deadline approaches with ominous music."
      "Schedule the quest before the moon falls."
      "Capture the thought before it disappears."
      "An empty heading awaits its destiny."
      "Fold the subtree. Its secrets remain hidden."
      "Unfold the subtree. The dungeon expands."
      "Your notes contain forgotten lore."
      "Somewhere in Org mode, everything is connected."
      "The quest is complete. Mark it DONE."
      "Another TODO appears immediately."
      "There is always another TODO."
      "The hero rests only after C-x C-s."
      "Save early. Save often. Save Hyrule."
      "Autosave is your fairy in a bottle."
      "Backup files remember fallen timelines."
      "The tilde file watches from the shadows."
      "Your changes are unsaved. The danger is real."
      "The buffer has been modified."
      "The buffer wishes to be saved."
      "Write the file and restore balance."
      "C-x C-s: the sound of progress."
      "C-x C-c: the final door."
      "Are you sure you want to leave this kingdom?"
      "Emacs has been running too long to quit now."
      "The session continues."
      "The adventure continues."
      "The cursor awaits."
      "The next command is yours."))
  :config
  (setq dashboard-banner-logo-title "Welcome")
  (setq dashboard-startup-banner (concat my-emacs-logo-directory "emax.png"))
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
    "a" '(org-agenda :which-key "agenda")
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
  :custom
  (doom-modeline-height 8)
  (doom-modeline-buffer-file-name-style 'truncated)
  (doom-modeline-major-mode-color nil)  ;; use default colors
  (doom-modeline-minor-modes nil)       ;; hide minor modes to save space
  :config
  (setq doom-modeline-bar-width 1))

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

(defvar my-org-task-file (concat my-org-directory "tasks.org"))
(defvar my-org-journal-file (concat my-org-directory "journal.org"))
(defvar my-org-habits-file (concat my-org-directory "habits.org"))
(defvar my-org-web-file (concat my-org-directory "web.org"))
(defvar my-org-roam-directory (concat my-org-directory "roam"))

(setq org-use-speed-commands t)

(setq org-priority-highest ?A
      org-priority-lowest ?C
      org-priority-default ?B)

(defun max/org-remove-ispell-capf ()
(setq-local completion-at-point-functions
            (remove #'ispell-completion-at-point
                    completion-at-point-functions)))

(defun max/org-mode-setup ()
  (org-indent-mode 1)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq-local line-spacing 0.15)
  (max/org-remove-ispell-capf))

(use-package org
  :hook (org-mode . max/org-mode-setup)
  :config
  (setq org-agenda-files (list my-org-task-file
			       my-org-habits-file)
	
	org-ellipsis " ▾"
	org-startup-folded 'content
	org-hide-emphasis-markers t
	org-hide-drawer-startup t
	
	
	org-log-done 'time
	org-log-into-drawer t
	
	org-agenda-start-with-log-mode nil

	org-auto-align-tags nil
	org-tags-column 0
	org-agenda-tags-column 0
	org-pretty-entities t

	org-format-latex-options
	(plist-put org-format-latex-options :scale 1.3)
	org-preview-latex-default-process 'dvisvgm)

  (require 'org-habit)
  (setq org-habit-graph-column 60))

(with-eval-after-load 'org-faces
  (set-face-attribute 'org-document-title nil
                      :inherit 'variable-pitch
                      :weight 'bold
                      :height 1.5)
  
  (dolist (face '((org-level-1 . 1.30)
	        (org-level-2 . 1.20)
		(org-level-3 . 1.12)
		(org-level-4 . 1.06)
		(org-level-5 . 1.00)
		(org-level-6 . 1.00)
		(org-level-7 . 1.00)
		(org-level-8 . 1.00)))
    (set-face-attribute (car face) nil
			:inherit 'variable-pitch
			:weight 'regular
			:height (cdr face)))
  
  (set-face-attribute 'org-block nil
		      :foreground nil
		      :inherit 'fixed-pitch)
  
  (set-face-attribute 'org-code nil
		      :inherit '(shadow fixed-pitch))
  
  (set-face-attribute 'org-hide nil
		      :inherit 'fixed-pitch)
  
  (set-face-attribute 'org-verbatim nil
		      :inherit '(shadow fixed-pitch))

  (set-face-attribute 'org-table nil
		      :inherit 'fixed-pitch)

  (set-face-attribute 'org-checkbox nil
		      :inherit 'fixed-pitch)
  
  (set-face-attribute 'org-special-keyword nil
		      :inherit '(font-lock-comment-face fixed-pitch))
  
  (set-face-attribute 'org-meta-line nil
		      :inherit '(font-lock-comment-face fixed-pitch)))

(with-eval-after-load 'org-indent
  (set-face-attribute 'org-indent nil
		        :inherit '(org-hide fixed-pitch)))

(defun max/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . max/org-mode-visual-fill))

(use-package org-modern
  :after org
  :config
  (global-org-modern-mode))

;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-todo-keywords
    '((sequence
       "IDEA(i)"
       "TODO(t)"
       "NEXT(n)"
       "WAIT(w@/!)"
       "|"
       "DONE(d!)"
       "CANCELLED(c@)")))

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

(defun max/org-agenda-skip-done-cancelled ()
  "Skip entries whose TODO state is DONE or CANCELLED."
  (org-agenda-skip-entry-if 'todo '("DONE" "CANCELLED")))

(defun max/org-agenda-skip-unless-direct-child-of (parent)
  "Skip entry unless it is a direct child of PARENT."
  (let ((subtree-end
       (save-excursion
         (org-end-of-subtree t))))
  (if (save-excursion
        (and (org-up-heading-safe)
             (string=
              (org-get-heading t t t t)
              parent)))
      nil
    subtree-end)))

(defun max/org-agenda-skip-unless-project ()
  (max/org-agenda-skip-unless-direct-child-of "Projects"))

(defun max/org-agenda-skip-unless-inbox ()
  (max/org-agenda-skip-unless-direct-child-of "Inbox"))

;; Configure custom agenda views
(setq org-agenda-custom-commands
      '(("i" "Ideas"
	 todo "IDEA"
	       ((org-agenda-overriding-header "Ideas")
		(org-agenda-max-todos 30)))
	
	("d" "Dashboard"
	 ((agenda ""
		 ((org-agenda-span 1)
		  (org-deadline-warning-days 7)
		  (org-agenda-overriding-header "Today")
		  (org-agenda-skip-function
		   #'max/org-agenda-skip-done-cancelled)))

	 (todo "NEXT"
	       ((org-agenda-overriding-header "Next Actions")
		(org-agenda-max-todos 20)
		(org-agenda-sorting-strategy
		 '(priority-down effort-up))))
	 
	 (todo "WAIT"
	       ((org-agenda-overriding-header "Waiting For")
		(org-agenda-max-todos 20)))
	 
	 (todo "IDEA"
	       ((org-agenda-overriding-header "Ideas")
		(org-agenda-max-todos 10)))
	 
	 (tags "LEVEL=2"
	       ((org-agenda-overriding-header "Projects")
		(org-agenda-files (list my-org-task-file))
		(org-agenda-skip-function
		 #'max/org-agenda-skip-unless-project)))
	 
	 (todo "TODO"
	       ((org-agenda-overriding-header "Inbox")
		(org-agenda-files (list my-org-task-file))
		(org-agenda-skip-function
		 #'max/org-agenda-skip-unless-inbox)))))
	
	("n" "Next Actions"
	 todo "NEXT"
	       ((org-agenda-overriding-header "Next Actions")
		(org-agenda-max-todos 30)
		(org-agenda-sorting-strategy
		 '(priority-down effort-up))))
	
	("w" "Waiting For"
	 todo "WAIT"
	       ((org-agenda-overriding-header "Waiting For")
		(org-agenda-max-todos 30)
		(org-agenda-sorting-strategy
		 '(deadline-up priority-down))))
	
	("p" "Projects"
	 tags "LEVEL=2"
	       ((org-agenda-overriding-header "Projects")
		(org-agenda-files (list my-org-task-file))
		(org-agenda-skip-function
		 #'max/org-agenda-skip-unless-project)))
	
	("e" "Quick Wins"
	 tags-todo "+EFFORT<=*15+EFFORT>*0/!+TODO|+NEXT"
		    ((org-agenda-overriding-header "15 Minutes or Under")
		     (org-agenda-max-todos 20)
		     (org-agenda-files (list my-org-task-file))))))

(defvar my-org-language-directory
    "~/Nextcloud/Documents/org-files/languages/")

  (defvar my-org-last-language nil)
  (defvar max/org-capture-todo-level 2)

  (defun max/org-projects ()
    "Return level-2 project headings from `my-org-task-file`."
    (with-current-buffer (find-file-noselect my-org-task-file)
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward "^\\* Projects[ \t]*$" nil t)
	  (let (projects)
	    (org-map-entries
	     (lambda ()
	       (push (org-get-heading t t t t) projects))
            "LEVEL=2"
            'tree)
          (nreverse projects))))))

  (defun max/org-capture-todo-target ()
    "Choose a project for a TODO capture, or Inbox if none is selected."
    (let ((project
	   (ivy-read
	    "Project (empty = Inbox): "
	    (cons "" (max/org-projects))
	    :require-match nil
	    :initial-input ""
	    :preselect "")))

      ;; Visit the actual capture file.
      (set-buffer (find-file-noselect my-org-task-file))
      (org-mode)
      ;; Find the desired parent headline.
      (goto-char (point-min))
      
      (if (string-empty-p project)
	  (re-search-forward "^\\* Inbox[ \t]*$" nil t)
	(progn
	  (re-search-forward "^\\* Projects[ \t]*$" nil t)
	  (let ((found nil))
	    (org-map-entries
	     (lambda ()
	       (when (string= (org-get-heading t t t t) project)
		 (setq found (point))))
	     "LEVEL=2"
	     'tree)
	    (if found
		(goto-char found)
	      (user-error "Project not found: %s" project)))))
      (beginning-of-line)))

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

  (defun max/org-capture-todo-stars ()
    "Return the appropriate number of stars for a captured task."
    (make-string max/org-capture-todo-level ?*))

  (setq org-capture-templates
      `(("t" "Task" entry
	(file+function my-org-task-file max/org-capture-todo-target)
	 "%(max/org-capture-todo-stars)* TODO %^{Task}
:PROPERTIES:
:CREATED: %U
:EFFORT: %^{Effort}
:END:
%?"
	 :empty-lines 1)

	("i" "Idea" entry
	 (file+headline my-org-task-file "Inbox")
	 "* IDEA %^{Idea}
:PROPERTIES:
:CREATED: %U
:EFFORT: %^{Effort}
:END:
%?"
	 :empty-lines 1)
	
	("w" "Waiting For" entry
	 (file+headline my-org-task-file "Inbox")
	 "* WAIT %^{What are you waiting for?}
:PROPERTIES:
:CREATED: %U
:WAITING_FOR: %^{Waiting for}
:WAITING_SINCE: %U
:END:
%?"
	 :empty-lines 1)
	
	("p" "Project" entry
	 (file+headline my-org-task-file "Projects")
	 "** %^{Project name}
:PROPERTIES:
:CREATED: %U
:END:

%?"
	 :empty-lines 1)

	("m" "Meeting" entry
	 (file+olp+datetree my-org-journal-file)
	 "* %<%H:%M> %^{Meeting title} :meeting:
:PROPERTIES:
:CREATED: %U
:END:

*Attendees*
%^{Attendees}

*Agenda*
%^{Agenda}

*Notes*
%?

*Decisions*

*Actions*
- TODO "
	 :empty-lines 1)

	("n" "Note" entry
	 (file+headline my-org-task-file "Inbox")
	 "* %^{Note title}
:PROPERTIES:
:CREATED: %U
:END:

%?"
	 :empty-lines 1)
        
	("j" "Journal" entry
	 (file+olp+datetree my-org-journal-file)
	 "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
	 :clock-in :clock-resume
	 :empty-lines 1)
	
	("v" "Vocabulary")
	("vb" "Basic" entry (function my-org-capture-anki-basic)
	 "* %^{Front}\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:END:\n\n%^{Back}\n\n")
	
	("e" "EWW article"
	 entry
	 (file my-org-web-file)
	 "* %a\n:PROPERTIES:\n:URL: %u\n:END:\n\n%?"
	 :empty-lines 1)))

  (defun max/org-set-waiting-for ()
    "Prompt for who/what a task is waiting for and record it."
  (when (and (string= org-state "WAIT")
      (not (string= org-last-state "WAIT")))
    (org-set-property
    "WAITING_FOR"
    (read-string "Waiting for: "))
    (org-set-property
    "WAITING_SINCE"
    (format-time-string "[%Y-%m-%d %a %H:%M]"))))

  (add-hook 'org-after-todo-state-change-hook #'max/org-set-waiting-for)

  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("rs" . "src rust"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (mermaid . t)))

(defun max/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
          (expand-file-name my-config-file))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'max/org-babel-tangle-config)))

(use-package ob-mermaid
  :config
  (setq ob-mermaid-default-config-file (concat my-config-directory "mermaid/mermaid-config.js")))

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil))

(defun org-roam-gaph--view (file)
  (find-file file))

(use-package org-roam
  :custom
  (org-roam-directory my-org-roam-directory)
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
  :hook (org-mode . org-fragtog-mode))

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
  (lsp-eldoc-render-all nil)
  (lsp-idle-delay 0.6)
  (lsp-completion-use-last-result t)
  ;; enable / disable the hints as you prefer:
  (lsp-inlay-hint-enable t)
  ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
  (lsp-rust-analyzer-cargo-watch-command "check")
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'right-fringe)   ;; show doc at point without overlapping
  (lsp-ui-peek-always-show nil)         ;; only show peek on demand
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package yasnippet :hook (lsp-mode . yas-minor-mode))

(max/leader-keys
  "d" '(lsp-ui-doc-show :which-key "show symbol doc"))

(use-package dap-mode
  :commands dap-debug
  :hook ((python-mode . dap-mode)
	 (python-mode . dap-ui-mode))
  :config
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)

  (defun dap-python--pyenv-executable-find (command)
    (with-venv (executable-find command))))

(use-package company
  :after lsp-mode
  :hook
  (lsp-mode . company-mode)
  (emacs-lisp-mode . (lambda ()
			(setq-local company-backends '(company-elisp))))
  (emacs-lisp-mode . company-mode)
  :bind (:map company-active-map
	  ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
	  ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.2)
  (company-backends '((company-capf :with company-yasnippet)))
  (company-selection-wrap-around t)
  (company-tooltip-align-annotations t)
  (company-transformers '(company-sort-by-occurrence
			  company-sort-by-backend-importance)))

(use-package company-box
  :hook (company-mode . company-box-mode)
  :custom
  (company-box-icons-alist 'company-box-icons-all-the-icons))

(use-package flycheck
  :ensure t)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p my-projects-directory)
    (setq projectile-project-search-path (list my-projects-directory)))
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

(use-package lsp-pyright
  :ensure t
  :after lsp-mode
  :custom
  ;; Let Pyright discover the virtual environment in the project.
  (lsp-pyright-venv-path nil)
  ;; Use the Python environment selected by the project when possible.
  (lsp-pyright-use-library-code-for-types t)
  ;; "openFilesOnly" is considerably less noisy on large projects.
  ;; Change to "workspace" if you want diagnostics for every file.
  (lsp-pyright-diagnostic-mode "openFilesOnly")
  ;; Type checking is useful for Python, especially when using type hints.
  (lsp-pyright-typechecking-mode "standard")
  ;; Pyright can provide useful completion from installed packages.
  (lsp-pyright-auto-import-completions t)
  ;; Prefer completion suggestions from the language server.
  (lsp-completion-enable t)
  (lsp-completion-enable-additional-text-edit t))

(use-package python-mode
  :hook (python-mode . lsp-deferred)
  :config
  (setq python-shell-interpreter "python3"))

(use-package rustic
  :ensure t
  :config
  (require 'lsp-rust)
  :custom
  (rustic-lsp-client 'lsp-mode)
  (rustic-format-on-save t))

(use-package sh-script
  :hook (sh-mode . lsp-deferred))

(defun my/latex-mode-hook ()
  (advice-add #'TeX-command-master :before (lambda (&rest r) (save-buffer)))
  (push (list 'output-pdf "Okular") TeX-view-program-selection))

(use-package auctex
  :ensure t
  :defer t
  :hook (LaTeX-mode . my/latex-mode-hook))

(use-package eca
  :vc (:url "https://github.com/editor-code-assistant/eca-emacs" :rev :newest))

;; Use a custom file so that emacs doesn't write in init.el
(setq custom-file "~/.config/emacs/.emacs.custom")

(when (file-exists-p custom-file)
  (load-file custom-file))

(setq org-refile-targets
      '((nil :maxlevel . 3)
        ("archive.org" :maxlevel . 2)))

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes nil)

;; Keep the target list focused on the current task system.
(setq org-refile-target-verify-function
      (lambda ()
        (not (member (org-get-heading t t t t)
                    '("Inbox")))))

;; Save Org files after refiling.
(advice-add 'org-refile :after #'org-save-all-org-buffers)

(use-package term
  :config
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-max-scrollback 20000)
  (setq vterm-kill-buffer-on-exit t)  ;; auto-kill buffer when shell exits
  :bind (("C-c t" . 'vterm-other-window)))

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
  (setq ebdb-sources '(my-edbd-directory))
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

(unless (file-directory-p my-downloads-directory)
  (make-directory my-downloads-directory))

(use-package eww
  :commands (eww eww-open-file)
  :init
  (setq eww-search-prefix "https://www.duckduckgo.com/search?q="
        eww-download-directory my-downloads-directory
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

(use-package osm
  :bind ("C-c m" . osm-prefix-map) ;; Alternatives: `osm-home' or `osm'

  :custom
  ;; Take a look at the customization group `osm' for more options.
  (osm-default-server 'default) ;; Configure the tile server
  (osm-default-zoom 15)         ;; Default zoom level
  (osm-copyright t)             ;; Display the copyright information
  (osm-home (list 52.52 13.40 10)))

(use-package password-store)

(use-package pass
  :after password-store
  :commands (pass))

(use-package mu4e
  :ensure nil
  :load-path my-mu4e-load-directory
  :config
  (setq mail-user-agent 'mu4e)

  (setq mu4e-mu-binary my-mu-binary)
  (setq mu4e-change-filenames-when-moving t)

  (setq mu4e-update-interval (* 3 60))     ;; Update every 3 minutes
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-index-lazy-check t)
  (setq mu4e-maildir my-mail-directory)
  
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
