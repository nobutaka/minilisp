(load "lib.lisp")

(define tfont (tfont))
(define TK_ESCAPE 164)

(defun loop ()
  (tigrTime)
  (while (and (if (= (tigrClosed screen) 0) t (exit 0)) (= (tigrKeyDown screen TK_ESCAPE) 0))
    (update (tigrTime))
    (tigrUpdate screen))
  (tigrUpdate screen))

(defun step ()
  (tigrTime)
  (update (tigrTime))
  (tigrUpdate screen))
