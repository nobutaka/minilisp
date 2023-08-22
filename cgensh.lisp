(load "cgen.lisp")

(define decls
  '((pointer? fopen string string)
    (number fclose pointer)
    (number putchar number)
    (void exit number)
    (void free pointer?)
    (number rand)
    (number sin number)))

(write-defs decls)
