(load "libgfx.lisp")

(define screen (tigrWindow 320 240 "Paint" 0))

(defun update ()
  (let1 m (tigrMouse screen)
    (let1 x (car m)
      (let1 y (cadr m)
        (let1 b (car (cddr m))
          (if (= b 1)
              (tigrFillCircle screen x y 8 (tigrRGB x y 255)))
          (if (= b 4)
              (tigrClear screen 0)))))))

(loop)
