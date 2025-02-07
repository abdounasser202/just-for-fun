;; My emacs config to put inside ~/.emacs.d/init.el ;;

;; For python and javascript support run these commands

;; install pip node and npm if not installed
;; sudo apt update
;; sudo apt install python3-pip
;; sudo apt install nodejs npm

;; make npm run without sudo
;; mkdir ~/.npm-global
;; npm config set prefix '~/.npm-global'
;; echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
;; source ~/.zshrc

;; install language servers
;; npm install -g typescript-language-server typescript
;; sudo apt-get install python3-pylsp


;; Initialize package sources
(require 'package)

;; Set up package repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("org" . "https://orgmode.org/elpa/")
                        ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize package system
(setq package-check-signature nil)
(package-initialize)

;; Refresh package contents if needed
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Configure use-package
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Disable startup message
(setq inhibit-startup-message t)

;; Disable visible scrollbar
(scroll-bar-mode -1)

;; Disable the toolbar
(tool-bar-mode -1)

;; Disable tooltips
(tooltip-mode -1)

;; Enable line numbers
(global-display-line-numbers-mode t)

;; Enable column numbers
(column-number-mode)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Set up visible bell
(setq visible-bell t)

(when window-system
  (set-frame-size (selected-frame) 175 60))

;; To make it apply to new frames as well:
(add-to-list 'default-frame-alist '(width . 175))
(add-to-list 'default-frame-alist '(height . 60))

;; ================================================================================================;;

;; Duplicate the current line and place cursor on the new line.
(defun duplicate-current-line ()
  (interactive)
  (let ((column (current-column)))
    (beginning-of-line)
    (let ((line-text (buffer-substring
                      (point)
                      (progn (end-of-line) (point)))))
      (newline)
      (insert line-text)
      (move-to-column column))))

(global-set-key (kbd "C-c d") 'duplicate-current-line)

;; Move line up and down
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key [(meta up)] 'move-line-up)
(global-set-key [(meta down)] 'move-line-down)

;; ================================================================================================;;

;; ivy for better completion
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
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; which-key to see available keybindings
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;;treemacs for file browsing
(use-package treemacs
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t t"   . treemacs)))

;;doom-themes
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t))

;;modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)
	   (doom-modeline-icon t)
   ))

;; Install and configure Magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Optional: Add Git indicators in the sidebar
(use-package treemacs-magit
  :after (treemacs magit))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(markdown-mode treemacs-magit magit doom-modeline doom-themes treemacs which-key counsel ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Markdown Mode
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc")
  :bind (:map markdown-mode-map
         ("C-c C-e" . markdown-do)))


;; Company for completion
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0))


;; Flycheck for syntax checking
(use-package flycheck
  :init (global-flycheck-mode))



;; LSP mode for language server protocol support
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((python-mode . lsp)
         (dart-mode . lsp)
         (js-mode . lsp)
         (js2-mode . lsp)
         (web-mode . lsp)
         (yaml-mode . lsp))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)

;; Python configuration
(use-package python-mode
  :hook (python-mode . (lambda ()
                        (setq python-indent-offset 4)
                        (setq tab-width 4))))

(use-package pyvenv
  :config
  (pyvenv-mode 1))

;; Dart and Flutter configuration
(use-package dart-mode
  :custom
  (dart-sdk-path "~/flutter/bin/cache/dart-sdk/"))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . flutter-run-or-hot-reload)))

;; JavaScript configuration
(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js2-basic-offset 2))

;; Web mode for HTML, CSS, and web templates
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx?\\'" . web-mode)
         ("\\.tsx?\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

;; Pour les fichiers .js standards
(use-package js2-mode
  :mode "\\.js\\'"
  :hook (js2-mode . js2-imenu-extras-mode)
  :config
  (setq js2-basic-offset 2)
  (setq js2-highlight-level 3))

(use-package js2-refactor
  :hook (js2-mode . js2-refactor-mode))

;; JSON mode
(use-package json-mode
  :mode "\\.json\\'")

;; YAML mode
(use-package yaml-mode
  :mode "\\.ya?ml\\'")

;; CSV mode
(use-package csv-mode
  :mode "\\.csv\\'")

;; Rainbow delimiters for better bracket matching
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Format all the things
(use-package format-all
  :hook (prog-mode . format-all-mode))

;; Tree-sitter for better syntax highlighting
(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  :hook ((python-mode . tree-sitter-hl-mode)
         (js-mode . tree-sitter-hl-mode)
         (dart-mode . tree-sitter-hl-mode)))

(use-package tree-sitter-langs)


;; Performance optimizations
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(setq lsp-idle-delay 0.500)

;; Backup file settings
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

;; Suppress docstring width warnings
(setq byte-compile-warnings '((not docstrings-wide)))


;; Icons fonts
(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; Emmet support
(use-package emmet-mode
  :hook ((web-mode . emmet-mode)
         (css-mode . emmet-mode))
  :config
  (setq emmet-move-cursor-between-quotes t)
  (setq emmet-self-closing-tag-style " /"))

  
;; Auto-save when focus is lost
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
  (setq super-save-remote-files nil))

;; XML support - nxml-mode is built into Emacs
(add-to-list 'auto-mode-alist '("\\.xml\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsd\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsl\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xslt\\'" . nxml-mode))

(with-eval-after-load 'nxml-mode
  (setq nxml-child-indent 4)
  (setq nxml-attribute-indent 4)
  (setq nxml-slash-auto-complete-flag t))  ;; Auto-close tags

;; Pretty print XML functions
(defun pretty-print-xml-region (begin end)
  "Pretty format XML markup in region."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region begin end)))

(defun pretty-print-xml-buffer ()
  "Pretty format XML markup in buffer."
  (interactive)
  (pretty-print-xml-region (point-min) (point-max)))

;; Add key binding for pretty-print in nxml-mode
(add-hook 'nxml-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-p") 'pretty-print-xml-buffer)))

;; Add custom keywords to org-todo-keywords
(setq org-todo-keywords
      '((sequence "TODO" "WIP" "DOING" "PAUSE" "|" "DONE")))

;; Optional: Define custom faces for the new keywords
(setq org-todo-keyword-faces
      '(("WIP" . (:foreground "orange" :weight bold))
        ("DOING" . (:foreground "yellow" :weight bold))
        ("PAUSE" . (:foreground "purple" :weight bold))))

;; Optional: Define fast selection keys for the new states
(setq org-todo-keywords-1
      '((sequence "TODO(t)" "WIP(w)" "DOING(d)" "PAUSE(p)" "|" "DONE(D)")))


(defun kill-all-buffers ()
  "Kill all buffers except *scratch*."
  (interactive)
  (mapc 'kill-buffer
        (delq (get-buffer "*scratch*")
              (buffer-list))))
