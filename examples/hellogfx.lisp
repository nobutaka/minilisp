(load "lib.lisp")
(load "libgfx.lisp")

(define screen (tigrWindow 320 240 "Hello" 0))
(while (and (= (tigrClosed screen) 0) (= (tigrKeyDown screen TK_ESCAPE) 0))
  (tigrClear screen (tigrRGB 128 144 160))
  (tigrPrint screen tfont 120 110 (tigrRGB 255 255 255) "Hello, world.")
  (tigrUpdate screen))
(tigrFree screen)
