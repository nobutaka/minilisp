(load "cgen.lisp")

(define decls '(
  (pointer tigrWindow number number string number)  ; Tigr *tigrWindow(int w, int h, const char *title, int flags);
  (void tigrFree pointer)                           ; void tigrFree(Tigr *bmp);
  (number tigrClosed pointer)                       ; int tigrClosed(Tigr *bmp);
  (void tigrUpdate pointer)                         ; void tigrUpdate(Tigr *bmp);
  (void tigrClear pointer number)                   ; void tigrClear(Tigr *bmp, TPixel color);
  (number tigrRGB number number number)             ; TPixel tigrRGB(unsigned char r, unsigned char g, unsigned char b)
  (number tigrKeyDown pointer number)               ; int tigrKeyDown(Tigr *bmp, int key);
))

(write-defs decls)
