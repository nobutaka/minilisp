(load "libgfx.lisp")

(define screen (tigrWindow 320 240 "Hello" 0))
(define x 0)

(defun update ()
  (setq x (+ x (* dt 16)))
  (tigrClear screen (tigrRGB 128 144 160))
  (tigrPrint screen tfont x 110 (tigrRGB 255 255 255) "Hello, world."))

(loop)
