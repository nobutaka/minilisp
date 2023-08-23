(load "cgen.lisp")

(define decls '(
  (void exit number)                                            ; void exit(int status);
  (pointer tigrWindow number number string number)              ; Tigr *tigrWindow(int w, int h, const char *title, int flags);
  (void tigrFree pointer)                                       ; void tigrFree(Tigr *bmp);
  (number tigrClosed pointer)                                   ; int tigrClosed(Tigr *bmp);
  (void tigrUpdate pointer)                                     ; void tigrUpdate(Tigr *bmp);
  (void tigrClear pointer number)                               ; void tigrClear(Tigr *bmp, TPixel color);
  (number tigrRGB number number number)                         ; TPixel tigrRGB(unsigned char r, unsigned char g, unsigned char b);
  (void tigrPrint pointer pointer number number number string)  ; void tigrPrint(Tigr *dest, TigrFont *font, int x, int y, TPixel color, const char *text, ...);
  (pointer tfont)                                               ; TigrFont *tfont;
  (number tigrKeyDown pointer number)                           ; int tigrKeyDown(Tigr *bmp, int key);
  (number tigrTime)                                             ; float tigrTime(void);
))

(write-defs decls)
