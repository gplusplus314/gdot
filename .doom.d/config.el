;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name (shell-command-to-string "git config user.name")
      user-mail-address (shell-command-to-string "git config user.email"))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; New stuff:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Like Vim's scrolloff
(setq scroll-margin 20)

;; Zoom in smaller increments
(setq text-scale-mode-amount 1.0)
(setq text-scale-mode-step 1.1)
(set-frame-font "SauceCodePro Nerd Font 16")

;; Mac-keyboard modifiers
(setq mac-command-modifier 'control)
(setq mac-right-command-modifier 'control)
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier 'meta)

;; Tabs the way I like them
(setq tab-width 2)
(setq-default indent-tabs-mode nil)

;; 80 column guide
(setq-default display-fill-column-indicator-column 79)
(global-display-fill-column-indicator-mode 1)
(set-face-attribute 'fill-column-indicator nil :foreground "black")

;; Stop using the system clipboard as default register
(setq select-enable-clipboard nil)

;; Clipboard util
(require 'simpleclip)

;;(setq neo-window-fixed-size nil)
;;;; Set the neo-window-width to the current width of the
;;;; neotree window, to trick neotree into resetting the
;;;; width back to the actual window width.
;;;; Fixes: https://github.com/jaypei/emacs-neotree/issues/262
;;(eval-after-load "neotree"
;;  '(add-to-list 'window-size-change-functions
;;    (lambda (_frame)
;;      (let ((neo-window (neo-global--get-window)))
;;        (unless (null neo-window)
;;          (setq neo-window-width (window-width neo-window)))))))

(setq projectile-switch-project-action 'neotree-projectile-action)
(setq projectile-track-known-projects-automatically nil)

(defun gh/set-agenda-files ()
  (interactive)
  (setq org-agenda-files (directory-files-recursively "~/org" "\\.org$"))
  )
(after! org
  (setq org-roam-capture-templates
        '(
          ("d" "default" plain "%?"
           :target (file+head "${slug}.org"
                              "#+title: ${title}\n")
           :unnarrowed t)))
  (advice-add 'org-agenda :before 'gh/set-agenda-files)
  (advice-add 'org-todo-list :before 'gh/set-agenda-files)
  (setq org-roam-directory "~/org/roam/")
  (setq org-roam-index-file "~/org/roam/index.org")
  (setq org-directory "~/org"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
        '(("arch" . "https://wiki.archlinux.org/index.php/")
          ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
        '((sequence
           "TODO(t)"         ; A task that is ready to be tackled
           "IN-PROG(i)"      ; A task that is in progress
           "STORY(s)"        ; A project that contains other tasks
           "BLOCKED(b)"      ; Something is holding up this task
           "IDEA"            ; Something that needs refinement
           "|"               ; The pipe necessary to separate "active" states and "inactive" states
           "DONE(d)"         ; Task has been completed
           "CANCELED(c)" ))
        org-todo-keyword-faces
        '(("TODO" . org-warning)
          ("IN-PROG" . "green")
          ("STORY" . "purple")
          ("BLOCKED" . "red")
          )) ; Task has been cancelled
  (set-face-attribute 'org-table nil :weight 'normal :height 1.0)
)
(require 'org-inlinetask)

;; Nice looking Org headings
(defun gh/disable-big-org-headings ()
  (interactive)
  (dolist
      (face
       '((org-level-1 1.0 ultra-bold)
         (org-level-2 1.0 extra-bold)
         (org-level-3 1.0 bold)
         (org-level-4 1.0 semi-bold)
         (org-level-5 1.0 normal)
         (org-level-6 1.0 normal)
         (org-level-7 1.0 normal)
         (org-level-8 1.0 normal)))
    (set-face-attribute (nth 0 face) nil :weight (nth 2 face) :height (nth 1 face)))
  )
(defun gh/enable-big-org-headings ()
  (interactive)
  (dolist
      (face
       '((org-level-1 1.7 ultra-bold)
         (org-level-2 1.6 extra-bold)
         (org-level-3 1.5 bold)
         (org-level-4 1.4 semi-bold)
         (org-level-5 1.3 normal)
         (org-level-6 1.2 normal)
         (org-level-7 1.1 normal)
         (org-level-8 1.0 normal)))
    (set-face-attribute (nth 0 face) nil :weight (nth 2 face) :height (nth 1 face)))
  )
(defun gh/toggle-big-org-headings ()
  (interactive)
  (if (get 'gh-big-org-headings 'state)
      (progn
        (put 'gh-big-org-headings 'state nil)
        (gh/disable-big-org-headings))
    (progn
      (put 'gh-big-org-headings 'state t)
      (gh/enable-big-org-headings)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybinds:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map! "C-S-V" #'simpleclip-paste)
(map! :leader "y" #'simpleclip-copy)

(map! "C-<left>" #'evil-window-left)
(map! "C-<down>" #'evil-window-down)
(map! "C-<up>" #'evil-window-up)
(map! "C-<right>" #'evil-window-right)

;;(map! :leader "t t" #'neotree-toggle)
(map! :leader :desc "treemacs" "." #'treemacs)

(map! :leader
      (:prefix ("f" . "find")
       :desc "file by name" "f" #'find-file
       :desc "org-roam node" "r" #'org-roam-node-find
       :desc "org note" "o" #'+default/org-notes-search
       ))

(map! :leader
      (:prefix ("t" . "toggle")
      :desc "toggle big Org headings" "o" #'gh/toggle-big-org-headings
      ))
