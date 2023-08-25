(load "lib.lisp")

(define tfont (tfont))
(define TK_C 67)
(define TK_ESCAPE 164)
(define dt 0)

;; ESC to exit loop and enter REPL.
(defun loop ()
  (tigrTime)
  (while (and (if (= (tigrClosed screen) 0) t (exit 0)) (= (tigrKeyDown screen TK_ESCAPE) 0))
    (setq dt (tigrTime))
    (update)
    (tigrUpdate screen))
  (tigrUpdate screen))

(defun step ()
  (setq dt (/ 60))
  (update)
  (tigrUpdate screen))
