;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 18 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 20))
(setq doom-font (font-spec :size 14.0))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(custom-theme-set-faces! 'doom-one
  '(default :background "#111111"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      :desc "Toggle Treemacs"
      "e" #'treemacs)

;; Terminal
(map! "C-/" #'+vterm/toggle)

;; Clipboard, yank, put handling
(after! evil
  ;; Paste from system clipboard in insert mode terminal-style
  (map! :i "S-C-v" #'clipboard-yank)
  (map! :leader
    :desc "Yank to clipboard"
    :v "y" #'clipboard-kill-ring-save))
;; don't use system clipboard by default
(setq select-enable-clipboard nil)
;; Do NOT overwrite the default register on visual paste
(setq evil-kill-on-visual-paste nil)


;; Treemacs
(after! treemacs
  (defun my/treemacs-create-nested ()
    "Prompt the user for a new file or directory path relative to the selected
    node, creating intermediate directories if necessary (like NerdTree 'a').
    A trailing slash in the input indicates a directory."
    (interactive)
    (let* (;; 1. Get the current node object (the 'button')
           (current-button (treemacs-current-button))
           ;; 2. Get the path property from the button object.
           (selected-path (when current-button
                            (treemacs-button-get current-button :path)))
           ;; Exit if no path could be determined (e.g., cursor is not on a node)
           (selected-path (or selected-path (treemacs-project-root)))
           ;; Ensure we are creating under a directory
           (base-dir (if (file-directory-p selected-path)
                         selected-path
                       (file-name-directory selected-path)))
           ;; Prompt the user for the new path
           (prompt-string (format "Create new file/dir under %s: "
               (file-name-nondirectory (directory-file-name base-dir))))
           (input (read-from-minibuffer prompt-string))
           ;; Combine base directory and user input
           (new-path (expand-file-name input (treemacs--add-trailing-slash base-dir))))
      (cond
       ;; If input ends with a slash (or the input is empty and treemacs added a slash), it's a directory
       ((or (string-suffix-p "/" input) (string-suffix-p "/" new-path))
        ;; Make directory, 't' ensures intermediate directories are created
        (make-directory new-path t)
        (message "Created directory path: %s" new-path))
       ;; Otherwise, it's a file
       (t
        ;; Create parent directories if they don't exist
        (make-directory (file-name-directory new-path) t)
        ;; Create an empty file
        (write-region "" nil new-path 'confirm)
        (message "Created file: %s" new-path)))
      ;; Refresh the view and go to the new node for better feedback
      (treemacs-refresh)
      (treemacs-goto-file-node new-path nil)
      (treemacs-pulse-on-success "Created %s." (propertize new-path 'face 'font-lock-string-face))))

  (define-key treemacs-mode-map (kbd "a") #'my/treemacs-create-nested)
  (define-key treemacs-mode-map (kbd ".") #'treemacs-root-down)
  (define-key treemacs-mode-map (kbd "<backspace>") #'treemacs-root-up))
