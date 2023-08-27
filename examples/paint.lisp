(load "libgfx.lisp")

(define screen (tigrWindow 320 240 "Paint" 0))

(defun update ()
  (define m (tigrMouse screen))
  (define x (car m))
  (define y (cadr m))
  (define b (caddr m))
  (if (= b 1)
      (tigrFillCircle screen x y 8 (tigrRGB x y 255)))
  (if (= b 4)
      (tigrClear screen 0)))

(loop)
