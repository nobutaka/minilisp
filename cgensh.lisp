(load "cgen.lisp")

(define decls '(
  (pointer? fopen string string)    ; FILE *fopen(const char *pathname, const char *mode);
  (number fclose pointer)           ; int fclose(FILE *stream);
  (number putchar number)           ; int putchar(int c);
  (void exit number)                ; void exit(int status);
  (void free pointer?)              ; void free(void *ptr);
  (number rand)                     ; int rand(void);
  (number sin number)               ; double sin(double x);
))

(write-defs decls)
