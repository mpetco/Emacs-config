(add-to-list 'load-path "~/.config/emacs/scripts/")

(require 'elpaca-setup)  ;; The Elpaca Package Manager
(require 'buffer-move)   ;; Buffer-move for better window managment

(use-package activities)

(use-package all-the-icons :ensure t :if (display-graphic-p))

(use-package
 all-the-icons-dired
 :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

;; fork this plugin and make it run and work like dmenu
(use-package app-launcher
  :ensure '(app-launcher :host github :repo "SebastienWae/app-launcher"))
(defun emacs-run-launcher ()
  "Create and select a frame called emacs-run-launcher which consists only of a minibuffer and has specific dimensions. Runs app-launcher-run-app on that frame, which is an emacs command that prompts you to select an app and open it in a dmenu like behaviour. Delete the frame after that command has exited"
  (interactive)
  (with-selected-frame 
    (make-frame '((name . "emacs-run-launcher")
                  (minibuffer . only)
                  (fullscreen . 0) ; no fullscreen
                  (undecorated . t) ; remove title bar
                  ;;(auto-raise . t) ; focus on this frame
                  ;;(tool-bar-lines . 0)
                  ;;(menu-bar-lines . 0)
                  (internal-border-width . 10)
                  (width . 80)
                  (height . 11)))
                  (unwind-protect
                    (app-launcher-run-app)
                    (delete-frame))))

(use-package
 cape
 :ensure t
 :defer 10
 :init
 (add-hook 'completion-at-point-functions #'cape-file) ;; you can complete files /bin/
 (add-hook 'completion-at-point-functions #'cape-dabbrev) ;; dabbrev pretty cool
 (add-hook 'completion-at-point-functions #'cape-dict) ;; dabbrev pretty cool
 (add-hook 'completion-at-point-functions #'yasnippet-capf) ;; yasnippets
 (add-hook 'completion-at-point-functions #'cape-elisp-block)

(defun my/eglot-capf ()
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'eglot-completion-at-point
                     #'yasnippet-capf))))
;; make functions by language so you can enable dabbrev for tex
;; make yasnippets load sepperately form everything else

(add-hook 'eglot-managed-mode-hook #'my/eglot-capf)
)

(use-package colorful-mode
 :ensure t
 :defer t
 :diminish
 :hook ((org-mode prog-mode) . colorful-mode))

(use-package consult)

(use-package
 corfu
 :ensure t
 :custom
 (corfu-cycle t) ;; allow cycling through candidates
 (corfu-auto t) ;; enable auto completion
 (corfu-auto-prefix 1) ;; minimum length for auto completion
 (corfu-auto-delay 0.0) ;; no delay might cause problems
 (corfu-popupinfo-delay '(0.5 . 0.2)) ;; vscode-like popups
 (corfu-echo-documentation t)
 (corfu-preselect 'prompt) ;; always preselect the prompt
 (corfu-on-exact-match nil) ;; Don't auto expand snippets
 :config
 (define-key corfu-map (kbd "C-k") (kbd "<up>"))
 (define-key corfu-map (kbd "C-j") (kbd "<down>"))
 ;; supertab-like behavior
 :bind (:map corfu-map
             ("M-SPC"      . corfu-insert-separator)
             ("TAB"        . corfu-next)
             ([tab]        . corfu-next)
             ("S-TAB"      . corfu-previous)
             ([backtab]    . corfu-previous)
             ("S-<return>" . corfu-insert)
             ("RET"        . corfu-insert)) ;; corfu insert deletes the )
 :init
 (global-corfu-mode)
 (corfu-history-mode)
 (corfu-popupinfo-mode))

(use-package
 nerd-icons-corfu
 :config (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package corfu-terminal)

(use-package
 dashboard
 :ensure t
 :init
 (setq initial-buffer-choice 'dashboard-open)
 (setq dashboard-set-heading-icons t)
 (setq dashboard-set-file-icons t)
 (setq dashboard-banner-logo-title "the extensible self-documenting integrated computing environment") ;; the first program, even before GCC, the optimus programus
 ;; rewrite this 
 ;;(defun dashboard-title ()
    ;;(let ((smaller-version 
	   ;;(replace-regexp-in-string (rx " (" (zero-or-more any) eol) "" (emacs-version))
	   ;;(replace-regexp-in-string (rx "2025" (zero-or-more any) eol) "" (emacs-version))))
      ;;(string-replace "\n" "" smaller-version) 
;;)
;;)
 ;;(setq dashboard-banner-logo-title (format "%s" (dashboard-title)))
 (setq dashboard-startup-banner "~/.config/emacs/dashboard-images/emacs.png") ;; use standard emacs logo as banner
 (setq dashboard-center-content t) ;; set to 't' for centered content
 (setq dashboard-items
       '((recents . 5)
         (agenda . 5)
         (bookmarks . 3)
         (projects . 3)
         (registers . 3)))
 (setq dashboard-item-shortcuts
       '((recents . "r")
         (bookmarks . "m")
         (projects . "p")
         (agenda . "a")
         (registers . "e")))
 :custom
 (dashboard-footer-messages '("From freedom came elegance!" "Where there is a shell, there is a way" "There's no place like 127.0.0.1" "Free as in freedom" "If you can read this, Xorg is still working" "Powered by Gentoo" "Powered by GNU/Linux" "u like regex.. dont u?" "Richard Stallman is proud of you" "“Talk is cheap. Show me the code.” \n         - Linus Torvalds" "“Well, what is a computer? A computer is a universal machine.” \n                       - Richard Stallman" "UNIX! Live Free or Die" "Linux is user friendly. It's just very picky about who its friends are." " “Intelligence is the ability to avoid doing work, yet getting the work done.” \n                               - Linus Torvalds" "Monolithic Multipurpose Xenodochial Xsystem" "Keep it simple, stupid!" "the quieter you become, the more you are able to hear" "Designed for GNU/Linux" "Certified for Microsoft© Windows™" "Certified for Windows Vista™" "Compatible with Windows®7" "Works with Windows Vista™" "Microsoft© Windows™ Capable" "Emacs is written in Lisp, which is the only computer language that is beautiful" "I showed you my source code, plz respond" "Configured by mpetco" "8MBs and constantly swapping" "a great operating system, lacking only a decent editor" "Eight Megabytes and Constantly Swapping" "Escape Meta Alt Control Shift" "EMACS Makes Any Computer Slow" "Eventually Munches All Computer Storage" "Generally Not Used, Except by Middle-Aged Computer Scientists" "How do you generate a random string? \n Put a web designer in front of vim" "vim is the leading cause of arthritis" "Given enough eyeballs all bugs are shallow" "“An idiot admires complexity, a genius admires simplicity”" "A great lisp interpreter" "lisp machine reference goes here" "lisp mathematical notation reference goes here" "The Optimus Programus" "Before There Was GCC, There Was Emacs" "The UNIX philosophy at it's finest" "The First Program, even before GCC" "Born in the Time of Terminals, Thriving still" "The One Editor to Rule Them All" "Eigth Wonder of the Coding World" "When RMS Dreamt in Lisp" "The UNIX Way, Amplified" "vim is a plugin" "Pure Lisp, Pure Bliss" "In Unix We Trust, in Emacs We Code" "A Pipe is Only as Strong as its Editor" "The Supreme Editor (by Decree)" "The Emperor's New Editor" "Bhraman in Lisp" "The Code of Daedulus" "The Tao of the computer" "the IDE of the project" "Pontifex sexpius"))
 (dashboard-footer-icon nil)
 (dashboard-modify-heading-icons
  '((recents . "file-text") (bookmarks . "book")))
 :config
 (add-hook
  'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
 (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
 (dashboard-setup-startup-hook))

;;(require 'desktop)
;;(desktop-save-mode t)
;;(setq desktop-auto-save-timeout 180)

(use-package diminish)

(use-package dired-open-with :defer t :ensure t)
;;(defun dpautoload-function () (message "test")) the functions has to be actually defined fyi

(use-package
 dired-preview
 :ensure t
 :defer t
 :commands dired-preview-mode
 :init (add-hook 'dired-mode-hook 'dired-preview-mode)
 :config (setq dired-preview-delay 0.3)
 (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
 (evil-define-key 'normal dired-mode-map (kbd "l") (kbd "RET")))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  ;; If non-nil, cause imenu to see `doom-modeline' declarations.
  ;; This is done by adjusting `lisp-imenu-generic-expression' to
  ;; include support for finding `doom-modeline-def-*' forms.
  ;; Must be set before loading doom-modeline.
  (doom-modeline-support-imenu t)

  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (doom-modeline-height 25)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (doom-modeline-bar-width 4)

  ;; Whether to use hud instead of default bar. It's only respected in GUI.
  (doom-modeline-hud nil)

  ;; The limit of the window width.
  ;; If `window-width' is smaller than the limit, some information won't be
  ;; displayed. It can be an integer or a float number. `nil' means no limit."
  (doom-modeline-window-width-limit 85)

  ;; Override attributes of the face used for padding.
  ;; If the space character is very thin in the modeline, for example if a
  ;; variable pitch font is used there, then segments may appear unusually close.
  ;; To use the space character from the `fixed-pitch' font family instead, set
  ;; this variable to `(list :family (face-attribute 'fixed-pitch :family))'.
  (doom-modeline-spc-face-overrides nil)

  ;; How to detect the project root.
  ;; nil means to use `default-directory'.
  ;; The project management packages have some issues on detecting project root.
  ;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
  ;; to hanle sub-projects.
  ;; You can specify one if you encounter the issue.
  (doom-modeline-project-detection 'auto)

  ;; Determines the style used by `doom-modeline-buffer-file-name'.
  ;;
  ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   auto => emacs/l/comint.el (in a project) or comint.el
  ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
  ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
  ;;   truncate-with-project => emacs/l/comint.el
  ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
  ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
  ;;   truncate-all => ~/P/F/e/l/comint.el
  ;;   truncate-nil => ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   relative-from-project => emacs/lisp/comint.el
  ;;   relative-to-project => lisp/comint.el
  ;;   file-name => comint.el
  ;;   file-name-with-project => FOSS|comint.el
  ;;   buffer-name => comint.el<2> (uniquify buffer name)
  ;;
  ;; If you are experiencing the laggy issue, especially while editing remote files
  ;; with tramp, please try `file-name' style.
  ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
  (doom-modeline-buffer-file-name-style 'auto)

  ;; Whether display icons in the mode-line.
  ;; While using the server mode in GUI, should set the value explicitly.
  (doom-modeline-icon t)

  ;; Whether display the icon for `major-mode'. It respects option `doom-modeline-icon'.
  (doom-modeline-major-mode-icon t)

  ;; Whether display the colorful icon for `major-mode'.
  ;; It respects `nerd-icons-color-icons'.
  (doom-modeline-major-mode-color-icon t)

  ;; Whether display the icon for the buffer state. It respects option `doom-modeline-icon'.
  (doom-modeline-buffer-state-icon t)

  ;; Whether display the modification icon for the buffer.
  ;; It respects option `doom-modeline-icon' and option `doom-modeline-buffer-state-icon'.
  (doom-modeline-buffer-modification-icon t)

  ;; Whether display the lsp icon. It respects option `doom-modeline-icon'.
  (doom-modeline-lsp-icon t)

  ;; Whether display the time icon. It respects option `doom-modeline-icon'.
  (doom-modeline-time-icon t)

  ;; Whether display the live icons of time.
  ;; It respects option `doom-modeline-icon' and option `doom-modeline-time-icon'.
  (doom-modeline-time-live-icon t)

  ;; Whether to use an analogue clock svg as the live time icon.
  ;; It respects options `doom-modeline-icon', `doom-modeline-time-icon', and `doom-modeline-time-live-icon'.
  (doom-modeline-time-analogue-clock t)

  ;; The scaling factor used when drawing the analogue clock.
  (doom-modeline-time-clock-size 0.7)

  ;; Whether to use unicode as a fallback (instead of ASCII) when not using icons.
  (doom-modeline-unicode-fallback nil)

  ;; Whether display the buffer name.
  (doom-modeline-buffer-name t)

  ;; Whether highlight the modified buffer name.
  (doom-modeline-highlight-modified-buffer-name t)

  ;; When non-nil, mode line displays column numbers zero-based.
  ;; See `column-number-indicator-zero-based'.
  (doom-modeline-column-zero-based t)

  ;; Specification of \"percentage offset\" of window through buffer.
  ;; See `mode-line-percent-position'.
  (doom-modeline-percent-position '(-3 "%p"))

  ;; Format used to display line numbers in the mode line.
  ;; See `mode-line-position-line-format'.
  (doom-modeline-position-line-format '("L%l"))

  ;; Format used to display column numbers in the mode line.
  ;; See `mode-line-position-column-format'.
  (doom-modeline-position-column-format '("C%c"))

  ;; Format used to display combined line/column numbers in the mode line. See `mode-line-position-column-line-format'.
  (doom-modeline-position-column-line-format '("%l:%c"))

  ;; Whether display the minor modes in the mode-line.
  (doom-modeline-minor-modes nil)

  ;; If non-nil, a word count will be added to the selection-info modeline segment.
  (doom-modeline-enable-word-count nil)

  ;; Major modes in which to display word count continuously.
  ;; Also applies to any derived modes. Respects `doom-modeline-enable-word-count'.
  ;; If it brings the sluggish issue, disable `doom-modeline-enable-word-count' or
  ;; remove the modes from `doom-modeline-continuous-word-count-modes'.
  (doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))

  ;; Whether display the buffer encoding.
  (doom-modeline-buffer-encoding nil)

  ;; Whether display the indentation information.
  (doom-modeline-indent-info nil)

  ;; Whether display the total line number。
  (doom-modeline-total-line-number nil)

  ;; Whether display the icon of vcs segment. It respects option `doom-modeline-icon'."
  (doom-modeline-vcs-icon t)

  ;; The maximum displayed length of the branch name of version control.
  (doom-modeline-vcs-max-length 15)

  ;; The function to display the branch name.
  (doom-modeline-vcs-display-function #'doom-modeline-vcs-name)

  ;; Whether display the icon of check segment. It respects option `doom-modeline-icon'.
  (doom-modeline-check-icon t)

  ;; If non-nil, only display one number for check information if applicable.
  (doom-modeline-check-simple-format nil)

  ;; The maximum number displayed for notifications.
  (doom-modeline-number-limit 99)

  ;; Whether display the project name. Non-nil to display in the mode-line.
  (doom-modeline-project-name t)

  ;; Whether display the workspace name. Non-nil to display in the mode-line.
  (doom-modeline-workspace-name t)

  ;; Whether display the perspective name. Non-nil to display in the mode-line.
  (doom-modeline-persp-name t)

  ;; If non nil the default perspective name is displayed in the mode-line.
  (doom-modeline-display-default-persp-name nil)

  ;; If non nil the perspective name is displayed alongside a folder icon.
  (doom-modeline-persp-icon t)

  ;; Whether display the `lsp' state. Non-nil to display in the mode-line.
  (doom-modeline-lsp t)

  ;; Whether display the GitHub notifications. It requires `ghub' package.
  (doom-modeline-github nil)

  ;; The interval of checking GitHub.
  (doom-modeline-github-interval (* 30 60))

  ;; Whether display the modal state.
  ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
  (doom-modeline-modal t)

  ;; Whether display the modal state icon.
  ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
  (doom-modeline-modal-icon t)

  ;; Whether display the modern icons for modals.
  (doom-modeline-modal-modern-icon t)

  ;; When non-nil, always show the register name when recording an evil macro.
  (doom-modeline-always-show-macro-register nil)

  ;; Whether display the mu4e notifications. It requires `mu4e-alert' package.
  (doom-modeline-mu4e nil)
  ;; also enable the start of mu4e-alert
  (mu4e-alert-enable-mode-line-display)

  ;; Whether display the gnus notifications.
  (doom-modeline-gnus t)

  ;; Whether gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
  (doom-modeline-gnus-timer 2)

  ;; Wheter groups should be excludede when gnus automatically being updated.
  (doom-modeline-gnus-excluded-groups '("dummy.group"))

  ;; Whether display the IRC notifications. It requires `circe' or `erc' package.
  (doom-modeline-irc t)

  ;; Function to stylize the irc buffer names.
  (doom-modeline-irc-stylize 'identity)

  ;; Whether display the battery status. It respects `display-battery-mode'.
  (doom-modeline-battery t)

  ;; Whether display the time. It respects `display-time-mode'.
  (doom-modeline-time t)

  ;; Whether display the misc segment on all mode lines.
  ;; If nil, display only if the mode line is active.
  (doom-modeline-display-misc-in-all-mode-lines t)

  ;; The function to handle `buffer-file-name'.
  (doom-modeline-buffer-file-name-function #'identity)

  ;; The function to handle `buffer-file-truename'.
  (doom-modeline-buffer-file-truename-function #'identity)

  ;; Whether display the environment version.
  (doom-modeline-env-version t)
  ;; Or for individual languages
  (doom-modeline-env-enable-python t)
  (doom-modeline-env-enable-ruby t)
  (doom-modeline-env-enable-perl t)
  (doom-modeline-env-enable-go t)
  (doom-modeline-env-enable-elixir t)
  (doom-modeline-env-enable-rust t)

  ;; Change the executables to use for the language version string
  (doom-modeline-env-python-executable "python") ; or `python-shell-interpreter'
  (doom-modeline-env-ruby-executable "ruby")
  (doom-modeline-env-perl-executable "perl")
  (doom-modeline-env-go-executable "go")
  (doom-modeline-env-elixir-executable "iex")
  (doom-modeline-env-rust-executable "rustc")

  ;; What to display as the version while a new one is being loaded
  (doom-modeline-env-load-string "...")

  ;; By default, almost all segments are displayed only in the active window. To
  ;; display such segments in all windows, specify e.g.
  (doom-modeline-always-visible-segments '(irc))

  ;; Hooks that run before/after the modeline version string is updated
  (doom-modeline-before-update-env-hook nil)
  (doom-modeline-after-update-env-hook nil))

;;(use-package eaf :ensure '(eaf :host github :repo "emacs-eaf/emacs-application-framework") :load-path "~/.config/emacs/site-lisp/emacs-application-framework`")

(setq epa-pinentry-mode 'loopback)

(use-package eat)

(use-package
 eglot
 :ensure t
 :config
 (add-to-list 'eglot-server-programs '(c-mode . ("clangd")))
 (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
 (add-to-list 'eglot-server-programs '(latex-mode . ("texlab")))
 (add-hook 'c-mode-hook 'eglot-ensure)
 (add-hook 'c++-mode-hook 'eglot-ensure)
 (add-hook 'latex-mode-hook 'eglot-ensure)
 ;; this fixes a bug, https://github.com/joaotavora/eglot/discussions/1127 https://www.reddit.com/r/emacs/comments/175moy8/eglot_gets_out_of_sync_from_the_buffer_and/
 (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
 (advice-add 'eglot-completion-at-point :around #'cape-wrap-noninterruptible))

(use-package jsonrpc)

(use-package embark)

(use-package embark-consult)

(use-package emms :config 
  (require 'emms-player-mpv)
(setq emms-player-list '(emms-player-mpv)))

(use-package
 elfeed
 :config
 (setq elfeed-db-directory "~/.cache/elfeed/")

  (defun play-elfeed-video ()
  "Play the URL of the entry at point in mpv if it's a YouTube video."
  (interactive)
  (let ((entry (elfeed-search-selected :single)))
    (if entry
        (let ((url (elfeed-entry-link entry)))
          (if (and url (string-match-p "https?://\\(www\\.\\)?youtube\\.com\\|youtu\\.be" url))
              (progn
                (shell-command (format "mpv '%s'" url))
                (elfeed-search-untag-all-unread))
            (message "The URL is not a YouTube link: %s" url)))
      (message "No entry selected in Elfeed."))))

  (defun play-elfeed-video2electric ()
  "Play the URL of the entry at point in mpv if it's a YouTube video."
  (interactive)
  (let ((entry (elfeed-search-selected :single)))
    (if entry
        (let ((url (elfeed-entry-link entry)))
          (if (and url (string-match-p "https?://\\(www\\.\\)?youtube\\.com\\|youtu\\.be" url))
              (progn
                (start-process "watch" nil (format "mpv '%s'" url))
                (elfeed-search-untag-all-unread))
            (message "The URL is not a YouTube link: %s" url)))
      (message "No entry selected in Elfeed."))))

  (defun bard/add-video-emms-queue ()
    "Play the URL of the entry at point in mpv if it's a YouTube video. Add it to EMMS queue."
    (interactive)
    (let ((entry (elfeed-search-selected :single)))
      (if entry
          (let ((url (elfeed-entry-link entry)))
            (if (and url (string-match-p "https?://\\(www\\.\\)?youtube\\.com\\|youtu\\.be" url))
                (let* ((playlist-name "Watch Later")
                       (playlist-buffer (get-buffer (format " *%s*" playlist-name))))
                  (unless playlist-buffer
                    (setq playlist-buffer (emms-playlist-new (format " *%s*" playlist-name))))
                  (emms-playlist-set-playlist-buffer playlist-buffer)
                  (emms-add-url url)
                  (elfeed-search-untag-all-unread)
                  (message "Added YouTube video to EMMS playlist: %s" url))
              (message "The URL is not a YouTube link: %s" url)))
        (message "No entry selected in Elfeed."))))

)

(use-package elfeed-org :config (elfeed-org) (setq rmh-elfeed-org-files (list "~/.config/emacs/elfeed.org.gpg")))

(use-package ellama
  :ensure t
  :bind ("C-c e" . ellama-transient-main-menu)
  ;; send last message in chat buffer with C-c C-c
  :hook (org-ctrl-c-ctrl-c-final . ellama-chat-send-last-message)
  :init (setopt ellama-auto-scroll t)
  :config
  ;; show ellama context in header line in all buffers
  (ellama-context-header-line-global-mode +1))

(use-package elpher)

(require 'erc)
(add-hook 'erc-mode 'erc-autojoin-mode)

(setq
 erc-server '(("irc.libera.chat" "irc.oftc.net"))
 erc-nick "JuvenilePrinceps"
 erc-user-full-name "Emacs User"
 erc-default-port "6697"
 erc-track-shorten-start 8 ;; minmum number of characters for a channel name in the modeline
 erc-autojoin-channels-alist '(("irc.libera.chat" "#gentoo" "#emacs" "#gnu" "#bitcoin" "#linux" "#sysadmin" "#uncyclopedia" "#lisp"))
 erc-kill-buffer-on-part t ;; kills buffer when you run the part (leave channel) command
 erc-auto-query 'bury) ;; create a query buffer every time you recieve a private message

(setq
 erc-fill-column 120 ;; the column at which a paragraph is broken
 erc-fill-function 'erc-fill-static
 erc-fill-static-center 20)

(setq
 erc-track-exclude '("#windows")
 erc-track-exclude-types '("JOIN" "NICK" "QUIT" "MODE" "AWAY") ;; list of messages to be ignored
 erc-hide-list '("JOIN" "NICK" "QUIT" "MODE" "AWAY") ;; message types to hide
 erc-track-exclude-server-buffer t)

(setq erc-track-visibility nil) ;; Only use the current frame for visibility

;; Tracking specific keywords or people
;; (setq erc-pals '("shom_" "masteroman" "benoitj")
;;             erc-fools '("daviwil-test")
;;             erc-keywords '("guix" "wiki"))

;; Desktop notifications for matches/mentions
(add-to-list 'erc-modules 'notifications)

;; Check spelling of messages
;; (add-to-list 'erc-modules 'spelling)

;; List active user's nicks in a side window 
(add-to-list 'erc-modules 'nickbar)

;; Uniquely colorize nicknames in chat
(add-to-list 'erc-modules 'nicks)

;; Displaying inline images
;;(use-package erc-image
;;  :ensure t
;;  :after erc
;;  :config
;;  (setq erc-image-inline-rescale 300)
;;  (add-to-list 'erc-modules 'image))

;;(setq erc-track-enable-keybindings t)

(setq erc-prompt-for-password nil)

(use-package
 evil
 :init ;; tweak evil's configuration before loading it
 (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
 (setq evil-want-keybinding nil)
 (setq evil-vsplit-window-right t)
 (setq evil-split-window-below t)
 (setq evil-undo-system 'undo-fu)
 (setq evil-want-C-u-scroll t)
 (evil-mode))

(use-package
 evil-collection
 :after evil
 :config
 ;;(setq evil-collection-mode-list '(dashboard dired ibuffer neotree magit vundo doc-view help elpaca package-menu buff-menu imenu buffer apropos cmake-mode snake tetris vterm vertico corfu eat eww))
 (evil-collection-init))

(use-package evil-tutor)

(use-package viper :disabled)

(defun efs/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 5)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

  ;; Rebind CapsLock to Ctrl
  ;; (start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")

  ;; Load the system tray before exwm-init
  (exwm-systemtray-mode 1)

  ;; cant use SPC
  ;; ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ;;?\SPC-wh
      ?\M-`
      ?\M-&
      ?\M-:
      ?\C-\M-j  ;; Buffer list
      ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  ;; dont rely on these for jack just getting out and into the regular way of doing things
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ;; ([?\M-r] . exwm-reset)

	  ;; System managment related
	  ([?\s-q] . (lambda (command) (interactive (shell-command "killall X"))))
	  ([?\s-x] . (lambda (command) (interactive (shell-command "~/.scripts/dmenu_action.sh"))))
	  ([?\s-s] . (lambda (command) (interactive (shell-command "flameshot gui"))))
	  ;; ([?\s-f] . (lambda (command) (interactive (shell-command "flameshot gui")))) exwm

          ;; Program managment
          ([?\s-r] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
	  ;;([?\s-d] . (start-process "dmenu" nil "/usr/local/bin/dmenu_run" "-vi"))
	  ;; use start process somehow
	  ([?\s-d] . (lambda (command) (interactive (shell-command "~/.scripts/dmenu_run_history.sh"))))

          ;; Window managment
          ([?\s-h] . evil-window-left)
          ([?\s-l] . evil-window-right)
          ([?\s-k] . evil-window-up)
          ([?\s-j] . evil-window-down)
          ([?\s--] . evil-window-split)
          ([?\s-\\] . evil-window-vsplit)
          ([?\s-c] . evil-window-delete)

	  ;; Buffer managment
          ([?\s-b] . switch-to-buffer)
          ([?\s-C] . kill-current-buffer)

	  ;; Layout managment
	  ;; please get this done so i dont have problems
          ;; Workspace managment
          ;; ([?\M-w] . exwm-workspace-switch)
          ([?\M-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))
)
  ;;(exwm-enable))

(use-package exwm-modeline)

;; Show battery status in the mode line
(add-hook 'exwm-init-hook 'display-battery-mode)

;; Show the time and date in modeline
(setq display-time-day-and-date t)
(add-hook 'exwm-init-hook 'display-time-mode)
;; Also take a look at display-time-format and format-time-string

(add-hook 'exwm-init-hook 'exwm-modeline-mode)

(use-package
 flycheck
 :ensure t
 :defer t
 :diminish
 :init (global-flycheck-mode))

(set-face-attribute 'default nil ;; default font
                    :font "Monaspace Argon"
                    :height 110
                    :weight 'medium)
(set-face-attribute 'variable-pitch nil ;; non-monospace (u use monaspace soo...)
		    :font "Monaspace Argon"
		    :height 120
		    :weight 'regular)
(set-face-attribute 'fixed-pitch nil ;; monospace
                    :font "Monaspace Argon"
                    :height 110
                    :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
;; (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
;; (set-face-attribute 'font-lock-keyword-face nil :slant 'italic)

;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "Monaspace Argon-11"))

;; Uncomment the following line if line spacing needs adjusting.
;; (setq-default line-spacing 0.12)

(use-package unicode-fonts)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package elisp-autofmt
     :config 
     (setq elisp-autofmt-python-bin "/usr/bin/python3.13"))

(use-package general
  :config
  (general-evil-setup)

 ;; (general-define-key
 ;;  :keymaps 'insert
 ;;  :prefix "SPC"
 ;;  ;; prefix keys are prepended to other keys, so "" refers to the prefix itself
 ;;  "s" '(lambda () (interactive) (evil-ex "%s/find/replace/gI"))) ;; visual mode selection

  ;; which-key is not the problem, emacs handles keybindings very differently
 ;; (general-define-key
 ;;  :keymaps 'insert
 ;;  :prefix "j"
 ;;  :ignore t
 ;;  ;; prefix keys are prepended to other keys, so "" refers to the prefix itself
 ;;  "j" 'evil-normal-state)

  ;; set up 'SPC' as the global leader key
  (general-create-definer leader-key
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader ;; you have to rewrite everything below in order to use meta as ur leader key
    :global-prefix "M-SPC") ;; access leader in insert mode

  ;; imported from my neovim config
  ;; the move one with c J K
  ;;(define-key evil-insert-state-map (kbd "jj") 'evil-normal-state) ;; turn off which key for this combo
  ;;(define-key evil-visual-state-map (kbd "jj") 'evil-normal-state)
  ;;(define-key evil-visual-state-map (kbd "J") (lambda (interactive) (call-interactively evil-ex ))) ;; it removes lines it doesnt move nothin
  ;; (define-key evil-visual-state-map (kbd "SPCj") 'evil-ex "m >+1<CR>gv=gv")
  ;; (define-key evil-visual-state-map (kbd "SPCk") 'evil-ex "m <-2<CR>gv=gv") ;; it exits visual mode that why it has problems
  ;; (leader-key 
  ;;   "s" '(lambda () (interactive) (evil-ex "%s/find/replace/gI")))

  (leader-key
    "b" '(:ignore t :wk "Buffer")
    "bb" '(switch-to-buffer :wk "Switch buffer")
    "bk" '(:ignore t :wk "Kill buffer")
    "bkt" '(kill-current-buffer :wk "Kill buffer")
    "bka" '(kill-buffer :wk "Kill another buffer")
    "bi" '(ibuffer :wk "Ibuffer") ;; ig this is like panes? in tmux
    "bn" '(next-buffer :wk "Next buffer")
    "bp" '(previous-buffer :wk "Previous buffer")
    "br" '(revert-buffer :wk "Reload buffer"))

  (leader-key
    "d" '(:ingore t :wk "Dired/Dashboard/Desktop Save")
    "dr" '(dashboard-open :wk "Refresh dashboard")
    "ds" '(desktop-save :wk "Save windows and buffers")
    ;; dired
    "dd" '(dired :wk "Open dired")
    "dj" '(dired-jump :wk "Dired jump to current")
    "do" '(dired-open-with :wk "Dired jump to current")
    "dp" '(dired-preview-mode :wk "Dired jump to current")
    "dn" '(neotree-dir :wk "Open directory in neotree"))

  (leader-key
    "e" '(:ignore t :wk "Eshell/Evaluate")    ;; not a command but a which key description
    "eb" '(eval-buffer :wk "Evaluate elisp in buffer")
    "ed" '(eval-defun :wk "Evaluate defun containing or after point")
    "ee" '(eval-expression :wk "Evaluate an elisp expression")
    ;;"ef" '(indent-pp-sexp :wk "Formate some elisp code")
    ;;"eh" '(esh-history :which-key "Eshell history")
    "el" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "er" '(eval-region :wk "Evaluate elisp in region")
    "es" '(eshell :which-key "Eshell"))

  (leader-key
    "SPC" '(execute-extended-command :wk "M-x")
    "." '(find-file :wk "Find file") ;; make this more like the one in neovim
    "fr" '(recentf :wk "Find recent files") ;; also fr h is a neovimism
    "fc" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "Edit emacs config")
    "h" '(:ignore t :wk "Help")
    "he" '(kill-emacs :wk "Exit emacs")
    "hf" '(describe-function :wk "Describe function")
    "hv" '(describe-variable :wk "Describe variable")
    "hk" '(describe-key :wk "Describe a key")
    ;;"hr" '(:ignore t :wk "Reload config") the one below was hrr
    "hr" '((lambda () (interactive) (load-file "~/.config/emacs/init.el")) :wk "Reload config")
    "TAB TAB" '(comment-line :wk "Comment lines they have to be in visual mode selected tho"))

  (leader-key
    "t" '(:ignore t :wk "Toggle")
    "tl" '(display-line-numbers-mode :wk "Toggle line numbers")
    "tn" '(neotree-toggle :wk "Toggle neotree file viewer")
    "tt" '(visual-line-mode :wk "Toggle truncated lines")
    "tu" '(vundo :wk "Toggle vundo tree")
    "tv" '(vterm-toggle :wk "Toggle vterm"))

  (leader-key
    "f" '(:ignore t :wk "Format/Find")
    ;; ff find file synonymous with . find-file
    "fe" '(:ignore t :wk "Format Elisp")
    "feb" '(elisp-autofmt-buffer :wk "Format the entire buffer")
    "fer" '(elisp-autofmt-region :wk "Format the selected text")
    "fl"  '(:ignore t :wk "Lsp format")
    "flr"  '(eglot-format :wk "Format region")
    "flb"  '(eglot-format-buffer :wk "Format buffer"))

  (leader-key
    "w" '(:ignore t :wk "Windows/Workspaces")
    ;; Workspaces
    "ww" '(exwm-workspace-switch :wk "Change workspace")
    "wm" '(exwm-workspace-move-window :wk "Move window to another workspace")
    ;; exwm-workspace-switch-to-buffer
    ;; Window splits
    "wc" '(evil-window-delete :wk "Close window")
    "wn" '(evil-window-new :wk "New window")
    "w-" '(evil-window-split :wk "Horizontal split window")
    "w\\" '(evil-window-vsplit :wk "Vertical split window")
    ;; Window motions
    "wh" '(evil-window-left :wk "Window left")
    "wj" '(evil-window-down :wk "Window down")
    "wk" '(evil-window-up :wk "Window up")
    "wl" '(evil-window-right :wk "Window right")
    ;;"ww" '(evil-window-next :wk "Goto next window")
    ;; Move Windows
    "wH" '(buf-move-left :wk "Buffer move left")
    "wJ" '(buf-move-down :wk "Buffer move down")
    "wK" '(buf-move-up :wk "Buffer move up")
    "wL" '(buf-move-right :wk "Buffer move right"))

  (leader-key 
    "n" '(:ignore t :wk "Org Roam")
    "nl" '(org-roam-buffer-toggle :wk "View all files linking to this file")
    "nf" '(org-roam-node-find :wk "Find notes")
    "ng"  '(org-roam-graph :wk "Show a graph of all of yours nodes")
    "ni"  '(org-roam-node-insert :wk "Insert a link to another node")
    "ne"  '(org-roam-ref-add :wk "Insert a reference")
    "nc"  '(org-roam-capture :wk "Capture a note into your personal wiki")
    "nj" '(org-roam-dailies-capture-today :wk "Org roam dailies")
    "nh" '(org-id-get-create :wk "Create a heading note")
    "nr" '(org-roam-node-random :wk "Open a random note")
    "nt" '(org-roam-tag-add :wk "Add a tag to a node")
    "na" '(org-roam-alias-add :wk "Create an alias for a note"))

  ;; Org timer
  (leader-key
    "r" '(:ignore t :wk "Window manager behavior")
    "rx" '((lambda (command) (interactive (shell-command "~/.scripts/dmenu_action.sh"))) :wk "Lock/Suspend/Poweroff/Reboot") ;; fix the wrong type error
    "rl" '(:ignore t :wk "Elfeed")
    "ry" '(:ignore t :wk "Explore youtube")
    "rp" '(:ignore t :wk "play a game (the casual preinstalled ones)")
    "rr" '((lambda (command) (interactive (list (read-shell-command "$ "))) (start-process-shell-command command nil command)) :wk "Launch a program"))

  ;; put the gtd stuff and roam stuff in here
  (leader-key
    "m" '(:ignore t :wk "Org")
    "ma" '(org-agenda :wk "Org agenda")
    "me" '(org-export-dispatch :wk "Org export dispatch")
    ;;"mi" '(org-toggle-item :wk "Org toggle item")
    "mI" '(org-toggle-inline-images :wk "Toggle images")
    "mP" '(org-download-clipboard :wk "Paste image")
    "mt" '(org-todo :wk "Org todo") ;; C-c C-t for the state of the entry
    "mT" '(org-ctrl-c-ctrl-c :wk "Set tags for an entry") ;; C-c C-c  for tags
    "mB" '(org-babel-tangle :wk "Org babel tangle")
    ;;"mc" '(org-toggle-checkbox :wk "Toggle between the states of a checkbox")
    "mh" '(org-id-get-create :wk "Create a heading note")
    "mo" '(org-open-at-point :wk "Open a link")
    "ml" '(org-insert-link :wk "Insert a link"))

  ;; Org timer
  (leader-key
    "mp" '(:ignore t :wk "Org timer")
    "mps" '(org-timer-set-timer :wk "Set a timer")
    "mpe" '(org-timer-stop :wk "End a timer")
    "mpp" '(org-timer-pause-or-continue :wk "Pause a timer"))

  ;; Org clock in out, i like this way of doing keychords
  (leader-key
    "me" '(org-set-effort :wk "Set effort")
    "mk" '(:ignore t :wk "Begin or end a task")
    "mki" '(org-clock-in :wk "Clock in on current task")
    "mko" '(org-clock-out :wk "Clock out on current task"))

  (leader-key
    "mb" '(:ignore t :wk "Tables")
    ;; add the create table with options org table create with, org table create 
    "mb-" '(org-table-insert-hline :wk "Insert hline in table"))

   ;; Org timestamps
  (leader-key
    "md" '(:ignore t :wk "Date/deadline")
    "mds" '(org-schedule :wk "Org schedule")
    "mdd" '(org-deadline :wk "Org deadline")
    "mdt" '(org-timestamp :wk "Org timestamp")
    "mdi" '(org-timestamp-inactive :wk "Org inactive timestamp"))
  
  ;; Org gtd related
  (leader-key
    "mf" '((lambda () (interactive) (cd "~/Notes/GTD") (call-interactively 'find-file)) :wk "Find GTD files")
    "mr" '(org-refile :wk "Refile into a project") ;; C-c C-w
    "mc" '(org-capture :wk "Capture an idea")
    "mi" '((lambda () (interactive) (org-capture nil "i")) :wk "Capture an idea directly into ur inbox")
    "mg" '((lambda () (interactive) (org-agenda nil "g")) :wk "View the GTD view in agendas directly"))

  (leader-key
    "g" '(:ingore t :wk "Git")
    "gs" '(magit-status :wk "Magit status"))
    ;;"gt" '(git-timemachine :wk "Git time machine")

  ;;leader-key a leasiure, rss reader, browser, irc chat, steam launcher minecraft launcher
  ;;(leader-key latexmk, and clean keybinding, and view keybinding
  (leader-key
    "l" '(:ingore t :wk "Latex")
    "lc" '((lambda () (interactive) (shell-command (format "/usr/bin/pdflatex" (shell-quote-argument (buffer-file-name))) ) ) :wk "Latex compile") ;; make it grab the current string of the open tex file
    "lv" '((lambda () (interactive) (dired buffer-file-name)) :wk "Latex view compiled"))

  ;; (leader-key 
  ;;   "c") write a few keybinds for compiling compile project compile file etc run compiled program

  (leader-key
    "p" '(projectile-command-map :wk "Projectile")))

;; (define-key global-map (kbd "C-.") 'company-files)

(require 'org)

;; Files
(setq org-directory "~/Notes/GTD/")
(setq org-agenda-files (list "inbox.org" "projects.org" "agenda.org"))

;; Capture
(setq org-capture-templates
      `(("i"
         "Inbox"
         entry
         (file "inbox.org")
         ,(concat "* TODO %?\n" "/Entered on/ %U")
         :prepend top
         :empty-lines-before 1)
        ("p"
         "Project"
         entry
         (file "projects.org")
         ,(concat "* TODO %?\n" "/Entered on/ %U\n"))
        ("m" "Scheduled" entry (file+headline "agenda.org" "Future")
         ,(concat
           "* TODO %? :meeting:\n" "SCHEDULED: <%^{yyyy-mm-dd}>"))
        ("d" "Deadline" entry (file+headline "agenda.org" "Future")
         ,(concat
           "* TODO %? :deadline:\n" "DEADLINE: <%^{yyyy-mm-dd}>"))
        ("r"
         "Recurrent"
         entry
         (file+headline "agenda.org" "Recurrent")
         ,(concat "* Reccurent event %?\n"))))

;; Use full window for org-capture
(add-hook 'org-capture-mode-hook 'delete-other-windows) ;; make it so the org select window is also the only window and change the C-c to anything else or better disable capture mode and use :w

;; Refile
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets '(("projects.org" :maxlevel . 4)))

;; TODO
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "COMPLETE(c)")))

(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

;; Agenda
(setq org-agenda-span 1)

;; maybe include a section for everything scheduled
(setq org-agenda-custom-commands
      '(("g" "Get Things Done (GTD) view"
         ((agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-deadline-warning-days 0)))
          (todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-format-date "")
                   (org-deadline-warning-days 7)
                   ;; (org-agenda-skip-function
                   ;;  '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header "\nDeadlines")))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header "\nInbox\n")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n")))))))

(use-package git-timemachine
  :after git-timemachine
  :hook (evil-normalize-keymaps . git-timemachine-hook)
  :config
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-j") 'git-timemachine-show-previous-revision)
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-k") 'git-timemachine-show-next-revision)
)

(use-package
 magit
 :custom
 (vc-handled-backends nil)
 (magit-section-initial-visibility-alist '((untracked . show)))
 :config
 (add-hook 'magit-process-find-password-functions 'magit-process-password-auth-source)) ;; automatically find git credentials, the first function doesnt exist so i have no idea how this works

(use-package git-gutter :hook (prog-mode . git-gutter))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(global-visual-line-mode t)

(setopt use-short-answers t)

;;(use-package lua-mode)
;;(use-package haskell-mode)

(add-hook 'LaTeX-mode-hook 'lsp)
(setq TeX-parse-self t)
;;(add-to-list 'auto-mode-alist '("\\.tex\\'" . 'lsp))

;;(use-package tex-mode :ensure nil)

(add-to-list 'auto-mode-alist '("\\.pdf\\'" . doc-view-mode))

(use-package marginalia :ensure t :config (marginalia-mode))

;;(use-package nyan-mode)

;;(add-to-list 'auto-mode-alist '("\\.org\\'" . org-display-inline-images))

(add-hook 'c++-mode-hook #'(lambda () (hs-minor-mode 1)))
(add-hook 'c-mode-hook #'(lambda () (hs-minor-mode 1)))

;;(use-package mule)

(use-package neotree
  :config
  (setq neo-smart-open t
        neo-theme "ascii"
        neo-show-hidden-files t
        neo-window-width 28
        neo-window-fixed-size nil
        inhibit-compacting-font-caches t
        projectile-switch-project-action 'neotree-projectile-action) 
        ;; truncate long file names in neotree
        (add-hook 'neo-after-create-hook
           #'(lambda (_)
               (with-current-buffer (get-buffer neo-buffer-name)
                 (setq truncate-lines t)
                 (setq word-wrap nil)
                 (make-local-variable 'auto-hscroll-mode)
                 (setq auto-hscroll-mode nil)))))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(setq org-latex-create-formula-image-program 'dvipng)

(use-package
  org-roam
  :ensure t
  :after org
  :custom
  (org-roam-directory (file-truename "~/Notes/PersonalWiki/"))
  (org-roam-completion-everywhere t)

  ;; configures templates for nodes
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :target (file+head "%<%Y%m%d%H%M%S>.org.gpg" "#+title: ${title}\n#+type: %^{type}\n#+filetags: %^{tags}")
      :unnarrowed t)
     ("m" "map of content" plain
      "* Topic Index\n- node1\n- node2 %?"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+type: %^{type}\n#+filetags: %^{tags}")
      :unnarrowed t)
     ("l" "programming language" plain
      "* Description\n%?\n* Characteristics\n Paradigm:\n Designed by:\n First appeared: %^{Year}\n Typing discipline:\n Filename extension: %^{Extension}\n Family:\n Influenced by:\n\n* Syntax\n(link to syntax reference)\n\n* Uses\n\n* Reference\n- some link\n- another link\n"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+type: %^{type}\n#+filetags: %^{tags}")
      :unnarrowed t)
     ("a" "author note" plain
      "\n* Source\n\nAuthor: \nTitle: ${title}\nType: \nGenre: \nYear: %^{Year}\n\n* Plot\n\n%?\n\n* Characters\n\n* Themes\n\n* Structure"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+type: %^{type}\n#+filetags: %^{tags}")
      :unnarrowed t)
     ("b" "book note" plain
      "\n* Source\n\nAuthor: %^{Author} \nTitle: ${title}\nType: %^{Type} \nGenre: %^{Genre} \nYear: %^{Year}\n\n* Plot\n\n%?\n\n* Characters\n\n* Themes\n\n* Structure"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+type: %^{type}\n#+filetags: %^{tags}")
      :unnarrowed t)
     ("y" "youtube script" plain
      "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%? insert those five points from that one tutorial"
      :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+type: %^{type}\n#+filetags: %^{tags}")
      :unnarrowed t)
     ))

  ;; configures the org roam buffer display for backlinks
  (add-to-list
   'display-buffer-alist
   '("\\*org-roam\\*"
     (display-buffer-in-direction)
     (direction . right)
     (window-width . 0.33)
     (window-height . fit-window-to-buffer)))

  ;; configures the org-roam-node-find menu
  (org-roam-node-display-template (concat "${type:10} ${title:25} " (propertize "${tags:150}" 'face 'org-tag)))
  :config 

  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    ;;(print (cadar (org-collect-keywords '("type") (file-truename "~/Notes/PersonalWiki/"))))
    ;;(org-roam-get-keyword "type" (org-roam-node-file node))
    (if (org-roam-node-file node)
        (with-temp-buffer
          (insert-file-contents (org-roam-node-file node) nil 0 nil)
          (org-roam--get-keyword "type"))
      (org-roam--get-keyword "type" nil)))

  (org-roam-db-autosync-enable)

  )

(use-package magit-section)

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-roam-ui
    :after org
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package
 toc-org
 :commands toc-org-enable
 :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package
 org-bullets
 :config
 (add-hook 'org-mode-hook 'org-indent-mode)
 (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-startup-with-inline-images t)
(setq org-image-actual-width nil)

(electric-indent-mode -1)
(setq org-edit-src-content-indentation 0)

(setq org-hide-emphasis-markers t)

(require 'tempo)

(font-lock-add-keywords
 'org-mode
 '(("^ *\\([-]\\) " (0 (prog1 ()
         (compose-region (match-beginning 1) (match-end 1) "•"))))))
;; add X emoji for - [X] yada yada

(setq org-clock-sound "~/.config/emacs/sounds/Bicycle-bell-2.wav")
(setq org-timer-default-timer 25)

;;(use-package org-backlink :ensure (:host github :repo "codecoll/org-backlink"))

(use-package org-download) ;;:config (setq org-download-image-dir "~/Notes/.images/"))
(setq org-download-image-dir "~/Notes/.images/")

(use-package ripgrep)
(use-package
 projectile
 :config
 (projectile-mode 1))

;;(use-package savehist :init (savehist-mode))
(savehist-mode)

(use-package
 eshell-syntax-highlighting
 :after esh-mode
 :config (eshell-syntax-highlighting-global-mode +1))

;; eshell-syntax-highlighting -- adds fish/zsh-like syntax highlighting.
;; eshell-rc-script -- your profile for eshell; like a bashrc for eshell.
;; eshell-aliases-file -- sets an aliases file for the eshell.

(setq
 eshell-rc-script (concat user-emacs-directory "eshell/profile")
 eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
 eshell-history-size 5000
 eshell-buffer-maximum-lines 5000
 eshell-hist-ignoredups t
 eshell-scroll-to-bottom-on-input t
 eshell-destroy-buffer-when-process-dies t
 eshell-visual-commands' ("bash" "fish" "htop" "ssh" "top" "zsh" "btop" "glances"))

(use-package
 vterm
 :config
 (setq
  vterm-shell "/usr/bin/fish"
  vterm-max-scrollback 5000))

(use-package
 vterm-toggle
 :after vterm
 :config
 (setq vterm-toggle-fullscreen-p nil)
 (setq vterm-toggle-scope 'project)
 (add-to-list
  'display-buffer-alist
  '((lambda (buffer-or-name _)
      (let ((buffer (get-buffer buffer-or-name)))
        (with-current-buffer buffer
          (or (equal major-mode 'vterm-mode)
              (string-prefix-p
               vterm-buffer-name (buffer-name buffer))))))
    (display-buffer-reuse-window display-buffer-at-bottom)
    ;;(display-buffer-reuse-window display-buffer-in-direction)
    ;;display-buffer-in-direction/direction/dedicated is added in emacs27
    ;;(direction . bottom)
    ;;(dedicated . t) ;dedicated is supported in emacs27
    (reusable-frames . visible) (window-height . 0.3))))

(use-package multi-vterm
	:config
	(add-hook 'vterm-mode-hook
			(lambda ()
			(setq-local evil-insert-state-cursor 'box)
			(evil-insert-state)))
	(define-key vterm-mode-map [return]                      #'vterm-send-return)

	(setq vterm-keymap-exceptions nil)
	(evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
	(evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	(evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
	(evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
	(evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
	(evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
	(evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
	(evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))

(use-package
 smartparens
 :ensure t
 :defer t
 :hook (prog-mode eglot org-mode latex-mode)
 :config (require 'smartparens-config))

(use-package
 yasnippet
 :config
 ;;(setq yas-snippet-dirs '("~/.config/emacs/snippets" "~/.config/emacs/elpaca/repos/yasnippet-snippets/snippets/"))
 (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :hook
  (prog-mode . yas-minor-mode)
  :bind
  (("C-c y n" . yas-new-snippet)
   ("C-c y v" . yas-visit-snippet-file)
   ("C-c y i" . yas-insert-snippet))
  :config
  (yas-reload-all))

(use-package yasnippet-capf
  :after cape
  :config
(setq yasnippet-capf-lookup-by 'name) ;; Prefer the name of the snippet instead
)

(use-package zenburn-theme :init (load-theme 'zenburn t))

(use-package transient)

(use-package typit :defer t)

(setq undo-limit 67108864) ;; 64mb.
(setq undo-strong-limit 100663296) ;; 96mb.
(setq undo-outer-limit 134217728) ;; 128mb.

(use-package
 vundo
 :config (setq vundo-glyph-alist vundo-unicode-symbols) (setq vundo-window-side 'top))

(use-package undo-fu)

(use-package undo-fu-session
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  (setq undo-fu-session-directory "~/.cache/undo-fu-session/")
  (undo-fu-session-global-mode))

(use-package
 vertico
 :ensure t
 :custom 
 (vertico-count 9)
 :init (vertico-mode)
 :config
 (define-key vertico-map (kbd "C-k") (kbd "<up>"))
 (define-key vertico-map (kbd "C-j") (kbd "<down>")))

(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package weather-scout :ensure (:host github :repo "hsolg/emacs-weather-scout"))

(require 'which-key)
(which-key-mode t)
(setq
 which-key-side-window-location 'bottom
 which-key-sort-order #'which-key-key-order-alpha
 which-key-sort-uppercase-first nil
 which-key-add-column-padding 1
 which-key-max-display-columns nil
 which-key-min-display-lines 6
 which-key-side-window-slot -10
 which-key-side-window-max-height 0.25
 which-key-idle-delay 0.8
 which-key-max-description-length 25
 which-key-allow-imprecise-window-fit nil
 which-key-separator " → ")
