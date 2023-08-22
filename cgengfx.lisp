(load "cgen.lisp")

(define decls '(
  (pointer tigrWindow number number string number)
  (void tigrFree pointer)
  (number tigrClosed pointer)
  (void tigrUpdate pointer)
  (void tigrClear pointer number)
  (number tigrRGB number number number)
  (number tigrKeyDown pointer number)
))

(write-defs decls)
