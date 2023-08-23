(load "lib.lisp")
(load "libgfx.lisp")

(define screen (tigrWindow 320 240 "Hello" 0))
(defun loop ()
  (tigrUpdate screen)
  (tigrTime)
  (while (= (tigrKeyDown screen TK_ESCAPE) 0)
    (if (not (= (tigrClosed screen) 0)) (exit 0))
    (tigrClear screen (tigrRGB 128 144 160))
    (tigrPrint screen tfont 120 110 (tigrRGB 255 255 255) "Hello, world.")
    (tigrUpdate screen)))

(loop)
