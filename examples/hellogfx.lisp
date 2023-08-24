(load "libgfx.lisp")

(define screen (tigrWindow 320 240 "Hello" 0))

(defun update ()
  (tigrClear screen (tigrRGB 128 144 160))
  (tigrPrint screen tfont 120 110 (tigrRGB 255 255 255) "Hello, world."))

(loop)
