;;; core-progress-bar.el --- Spacemacs Core File
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3
(require 'core-spacemacs-buffer)

(defvar spacemacs-loading-char ?█)
(defvar spacemacs-loading-char-light ?░)
(defvar spacemacs-loading-string "")
(defvar spacemacs-loading-counter 0)
(defvar spacemacs-loading-value 0)
(defvar spacemacs-loading-dots-chunk-count 5)
(defvar spacemacs-loading-dots-count 0)
(defvar spacemacs-loading-dots-chunk-size 0)
(defvar spacemacs-loading-dots-chunk-threshold 0)

(defun spacemacs/init-progress-bar (max)
  "Initialize the progress bar."
  (setq spacemacs-loading-dots-count (window-total-size nil 'width))
  (setq spacemacs-loading-dots-chunk-size (/ spacemacs-loading-dots-count
                                             spacemacs-loading-dots-chunk-count))
  (setq spacemacs-loading-dots-chunk-threshold
        (- (/ max spacemacs-loading-dots-chunk-count) 5))
  (setq spacemacs-loading-counter 0)
  (setq spacemacs-loading-value 0)
  (spacemacs-buffer/set-mode-line (make-string spacemacs-loading-dots-count
                                               spacemacs-loading-char-light))
  (spacemacs//redisplay))

(defun spacemacs/update-progress-bar ()
  "Update progress bar by incrementing its value by 1.
Display the progress bar by chunks of size `spacemacs--loading-dots-chunk-threshold'"
  (when (and (not noninteractive)
             dotspacemacs-loading-progress-bar)
    (setq spacemacs-loading-counter (1+ spacemacs-loading-counter))
    (setq spacemacs-loading-value (1+ spacemacs-loading-value))
    (when (>= spacemacs-loading-counter
              spacemacs-loading-dots-chunk-threshold)
      (let* ((progress
              (max 0 (* spacemacs-loading-dots-chunk-size
                        (floor (/ spacemacs-loading-value
                                  spacemacs-loading-dots-chunk-threshold)))))
             (remain (max 0 (- spacemacs-loading-dots-count progress))))
        (setq spacemacs-loading-counter 0)
        (setq spacemacs-loading-string
              (concat (make-string progress spacemacs-loading-char)
                      (make-string remain spacemacs-loading-char-light)))
        (spacemacs-buffer/set-mode-line spacemacs-loading-string))
      (spacemacs//redisplay))))

(provide 'core-progress-bar)
