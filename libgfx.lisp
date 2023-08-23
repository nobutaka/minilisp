(load "lib.lisp")

(define tfont (tfont))
(define TK_ESCAPE 164)

(defun loop ()
  (tigrTime)
  (tigrUpdate screen)
  (while (and (if (= (tigrClosed screen) 0) t (exit 0)) (= (tigrKeyDown screen TK_ESCAPE) 0))
    (update)
    (tigrUpdate screen)))
