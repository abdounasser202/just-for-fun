;; My emacs config to put inside ~/.emacs.d/init.el

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
  (set-frame-size (selected-frame) 175 65))

;; To make it apply to new frames as well:
(add-to-list 'default-frame-alist '(width . 175))
(add-to-list 'default-frame-alist '(height . 65))

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
  :custom ((doom-modeline-height 15)))

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
