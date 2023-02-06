;;; package -- Sumary
;;(require 'ob-tangle)
(require 'package)
;(org-babel-load-file
;(expand-file-name "configuration.org"
 ;                user-emacs-directory))
(require 'term)
(package-initialize)

(setq user-full-name "Capitain Khop")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-display-line-numbers-mode t)

(global-set-key (kbd "C-t") 'open-term-right)
(global-set-key (kbd "C-r") 'close-terminals)
(global-set-key (kbd "C-e") 'excect-term-right)

(load-file "~/.emacs.d/configuration.el")
;;(remove-hook 'rust-mode-hook #'lsp)
(load-theme 'doom-gruvbox t t)
(provide 'init)


