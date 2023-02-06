(defun efs/mostrar-tiempo-a()
   (message "Listo en %s con %d garbage collections."
            (format "%.2f segundos"
                (float-time
                      (time-subtract after-init-time before-init-time)))
                     gcs-done))
(add-hook 'emacs-startup-hook #'efs/mostrar-tiempo-a)

(setf package-archives (list '("gnu" . "http://elpa.gnu.org/packages/")
                                   '("melpa" . "http://melpa.org/packages/")
                                   '("org" . "http://orgmode.org/elpa/")))
(defvar terminal "bash")
(defun open-term-right ()
  (interactive)
  (funcall 'close-terminals)
  (split-window-vertically)
  (other-window 1)
  (shrink-window 15)
  (shell terminal)
  )

(defvar ruta-buffer "")

(defun excect-term-right ()
  (interactive)
  (funcall 'close-terminals)
  (setq ruta-buffer (file-name-directory buffer-file-name))
  (split-window-horizontally)
  (other-window 1)
  (shrink-window-horizontally 25)
  (shell terminal)
  (term-send-string (get-buffer-process terminal) (concat "hola " ruta-buffer "\n"))       
  )

(defun close-terminals ()
  (interactive)
  (let ((buf (get-buffer terminal)))
    (if buf
	(let ((buffer-modified-p nil))
	  (let ((proc (get-buffer-process buf)))
	    (delete-window (get-buffer-window buf))
	    (if proc
		(set-process-query-on-exit-flag proc nil)
	      )
	    (if proc
		(kill-process proc)
	      )
	    (kill-buffer buf)
	    )))
    )
  )

(setf
 inhibit-startup-message t
 initial-scratch-message nil
   shift-select-mode t 
   blink-matching-paren nil
   recent-max-saved-items 100
   history-length 200
   x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)
   enable-recursive-minibuffers t
   custom-file (expand-file-name "custom.el" user-emacs-directory)
   )

(prefer-coding-system 'utf-8)
(if
    (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setf default-buffer-file-coding-system 'utf-8))

(load custom-file)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-x 2") (lambda ()
                                (interactive)
                                (split-window-vertically)
                                (other-window 1)
				)
		)

(global-set-key (kbd "C-h C-m") 'discover-my-major)

(add-hook 'prog-mode-hook (lambda ()
                             ;; Variables locales segun el gancho que sea activado
                             (set (make-local-variable 'fill-column) 79)
                             (set (make-local-variable 'comment-auto-fill-only-comments) t)
                             (auto-fill-mode t)
                             ;;(toggle-truncate-lines)
                             (highlight-numbers-mode)
                             (global-pretty-mode t)
                              )
         )

;; Esto es para que al dar enter se idente en automatico (electric?)
(define-key prog-mode-map (kbd "RET") 'newline-and-indent)

(add-hook 'text-mode-hook (lambda ()
                              ;; Variables locales segun el gancho que sea activado
                              (set (make-local-variable 'fill-column) 110)
                              (auto-fill-mode)                           
                              )
          )

;;Company para emacs.
(use-package flycheck :ensure)
(with-eval-after-load 'rust-mode
  (add-hook 'rust-mode-hook #'pretty-mode)
  (add-hook 'rust-mode-hook #'company-mode)
;;  (add-hook 'rust-mode-hook #'flycheck-mode)
;;  (add-hook 'rust-mode-hook #'prog-mode)
  )
;; for Cargo.toml and other config files
;; (use-package toml-mode :ensure)
