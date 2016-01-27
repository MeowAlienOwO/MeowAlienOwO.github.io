;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- Mode: Emacs-Lisp -*- ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; .hyde.el --- 
;; Filename: .hyde.el
;; Description: 
;; Author: Zhang Huayan
;; ID number: 6511043
;; E-mail: zy11043@nottingham.edu.cn / MeowAlienOwO@gmail.com
;; Version: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary: 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Change Log:
;; Status: 
;; Table of Contents: 
;; 
;;     Update #: 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code:

;; (setq hyde/git/remote "origin" ; The name of the remote to which we should push
;;       hyde/git/remote-branch "master"   ; The name of the branch on which your blog resides
;;       hyde/deploy-command  "make deploy" ; Command to deploy
;;       )

(setq hyde/git/remote "origin" ; The name of the remote to which we should push
      hyde/git/remote "master"   ; The name of the branch on which your blog resides
      hyde/deploy-command "make deploy" 
      ;; hyde/deploy-command  "rsync -vr _site/* nkv@ssh.hcoop.net:/afs/hcoop.net/user/n/nk/nkv/public_html/nibrahim.net.in/" ; Command to deploy
      hyde-custom-params '(("categories" "")
                           ("tags" "")
			   ("image" "")
			   ("  feature" "")
			   ("  credit" "")
                           ("  creditlink" "")
                           ("comments" ""))
      )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; .hyde.el ends here
