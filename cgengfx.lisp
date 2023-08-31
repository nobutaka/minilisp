(load "cgen.lisp")

(define decls '(
  (void exit number)                                            ; void exit(int status);
  (pointer tigrWindow number number string number)              ; Tigr *tigrWindow(int w, int h, const char *title, int flags);
  (void tigrFree pointer)                                       ; void tigrFree(Tigr *bmp);
  (number tigrClosed pointer)                                   ; int tigrClosed(Tigr *bmp);
  (void tigrUpdate pointer)                                     ; void tigrUpdate(Tigr *bmp);
  (void tigrClear pointer number)                               ; void tigrClear(Tigr *bmp, TPixel color);
  (void tigrLine pointer number number number number number)    ; void tigrLine(Tigr *bmp, int x0, int y0, int x1, int y1, TPixel color);
  (void tigrCircle pointer number number number number)         ; void tigrCircle(Tigr *bmp, int x, int y, int r, TPixel color);
  (void tigrFillCircle pointer number number number number)     ; void tigrFillCircle(Tigr *bmp, int x, int y, int r, TPixel color);
  (number tigrRGB number number number)                         ; TPixel tigrRGB(unsigned char r, unsigned char g, unsigned char b);
  (number tigrRGBA number number number number)                 ; TPixel tigrRGBA(unsigned char r, unsigned char g, unsigned char b, unsigned char a);
  (void tigrPrint pointer pointer number number number string)  ; void tigrPrint(Tigr *dest, TigrFont *font, int x, int y, TPixel color, const char *text, ...);
  (pointer tfont)                                               ; TigrFont *tfont;
  (cell tigrMouse pointer)                                      ; void tigrMouse(Tigr *bmp, int *x, int *y, int *buttons);
  (number tigrKeyDown pointer number)                           ; int tigrKeyDown(Tigr *bmp, int key);
  (number tigrTime)                                             ; float tigrTime(void);
))

(write-defs decls)
