#include "minilisp.c"
#include "tigr.h"

//======================================================================
// C library functions
//======================================================================

static uint32_t packTPixel(TPixel p) {
    return *(uint32_t *)&p;
}

static TPixel unpackTPixel(uint32_t p) {
    return *(TPixel *)&p;
}

// (tigr)
static Obj *prim_tigr(void *root, Obj **env, Obj **list) {
    Tigr *screen = tigrWindow(320, 240, "minigfx", 0);
    while (!tigrClosed(screen) && !tigrKeyDown(screen, TK_ESCAPE)) {
        tigrClear(screen, tigrRGB(0x80, 0x90, 0xa0));
        tigrPrint(screen, tfont, 120, 110, tigrRGB(0xff, 0xff, 0xff), "Hello, world.");
        tigrUpdate(screen);
    }
    tigrFree(screen);
    return Nil;
}

static void define_library(void *root, Obj **env) {
    add_primitive(root, env, "tigr", prim_tigr);
}

//======================================================================
// Entry point
//======================================================================

int main(int argc, char *argv[]) {
    // Memory allocation
    memory = alloc_semispace();

    // Constants, primitives and library
    Symbols = Nil;
    void *root = NULL;
    DEFINE1(env);
    *env = make_env(root, &Nil, &Nil);
    define_constants(root, env);
    define_primitives(root, env);
    define_library(root, env);

    // Mark a return point
    if (setjmp(exception_env) != 0)
        exit(1);

    // Set up the reader
    input = 1 < argc ? fopen(argv[1], "r") : stdin;

    // The main loop
    return repl(root, env, false);
}
