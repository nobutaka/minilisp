#include "minilisp.c"
#include "tigr.h"

//======================================================================
// C library functions
//======================================================================

// (exit <number>) -> <void>
static Obj *prim_exit(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed exit");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    exit(arg0->value);
    return Nil;
}

//======================================================================
// TIGR functions
//======================================================================

static uint32_t packTPixel(TPixel p) {
    return *(uint32_t *)&p;
}

static TPixel unpackTPixel(uint32_t p) {
    return *(TPixel *)&p;
}

// (tigrWindow <number> <number> <string> <number>) -> <pointer>
static Obj *prim_tigrWindow(void *root, Obj **env, Obj **list) {
    if (length(*list) != 4)
        error("Malformed tigrWindow");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    Obj *arg2 = args->cdr->cdr->car;
    Obj *arg3 = args->cdr->cdr->cdr->car;
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    if (arg2->type != TSTRING)
        error("Parameter #2 must be a string");
    if (arg3->type != TNUMBER)
        error("Parameter #3 must be a number");
    return make_pointer(root, tigrWindow(arg0->value, arg1->value, arg2->str, arg3->value));
}

// (tigrFree <pointer>) -> <void>
static Obj *prim_tigrFree(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed tigrFree");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    tigrFree(arg0->ptr);
    return Nil;
}

// (tigrClosed <pointer>) -> <number>
static Obj *prim_tigrClosed(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed tigrClosed");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    return make_number(root, tigrClosed(arg0->ptr));
}

// (tigrUpdate <pointer>) -> <void>
static Obj *prim_tigrUpdate(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed tigrUpdate");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    tigrUpdate(arg0->ptr);
    return Nil;
}

// (tigrClear <pointer> <number>) -> <void>
static Obj *prim_tigrClear(void *root, Obj **env, Obj **list) {
    if (length(*list) != 2)
        error("Malformed tigrClear");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    tigrClear(arg0->ptr, unpackTPixel(arg1->value));
    return Nil;
}

// (tigrLine <pointer> <number> <number> <number> <number> <number>) -> <void>
static Obj *prim_tigrLine(void *root, Obj **env, Obj **list) {
    if (length(*list) != 6)
        error("Malformed tigrLine");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    Obj *arg2 = args->cdr->cdr->car;
    Obj *arg3 = args->cdr->cdr->cdr->car;
    Obj *arg4 = args->cdr->cdr->cdr->cdr->car;
    Obj *arg5 = args->cdr->cdr->cdr->cdr->cdr->car;
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    if (arg2->type != TNUMBER)
        error("Parameter #2 must be a number");
    if (arg3->type != TNUMBER)
        error("Parameter #3 must be a number");
    if (arg4->type != TNUMBER)
        error("Parameter #4 must be a number");
    if (arg5->type != TNUMBER)
        error("Parameter #5 must be a number");
    tigrLine(arg0->ptr, arg1->value, arg2->value, arg3->value, arg4->value, unpackTPixel(arg5->value));
    return Nil;
}

// (tigrCircle <pointer> <number> <number> <number> <number>) -> <void>
static Obj *prim_tigrCircle(void *root, Obj **env, Obj **list) {
    if (length(*list) != 5)
        error("Malformed tigrCircle");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    Obj *arg2 = args->cdr->cdr->car;
    Obj *arg3 = args->cdr->cdr->cdr->car;
    Obj *arg4 = args->cdr->cdr->cdr->cdr->car;
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    if (arg2->type != TNUMBER)
        error("Parameter #2 must be a number");
    if (arg3->type != TNUMBER)
        error("Parameter #3 must be a number");
    if (arg4->type != TNUMBER)
        error("Parameter #4 must be a number");
    tigrCircle(arg0->ptr, arg1->value, arg2->value, arg3->value, unpackTPixel(arg4->value));
    return Nil;
}

// (tigrFillCircle <pointer> <number> <number> <number> <number>) -> <void>
static Obj *prim_tigrFillCircle(void *root, Obj **env, Obj **list) {
    if (length(*list) != 5)
        error("Malformed tigrFillCircle");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    Obj *arg2 = args->cdr->cdr->car;
    Obj *arg3 = args->cdr->cdr->cdr->car;
    Obj *arg4 = args->cdr->cdr->cdr->cdr->car;
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    if (arg2->type != TNUMBER)
        error("Parameter #2 must be a number");
    if (arg3->type != TNUMBER)
        error("Parameter #3 must be a number");
    if (arg4->type != TNUMBER)
        error("Parameter #4 must be a number");
    tigrFillCircle(arg0->ptr, arg1->value, arg2->value, arg3->value, unpackTPixel(arg4->value));
    return Nil;
}

// (tigrRGB <number> <number> <number>) -> <number>
static Obj *prim_tigrRGB(void *root, Obj **env, Obj **list) {
    if (length(*list) != 3)
        error("Malformed tigrRGB");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    Obj *arg2 = args->cdr->cdr->car;
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    if (arg2->type != TNUMBER)
        error("Parameter #2 must be a number");
    return make_number(root, packTPixel(tigrRGB(arg0->value, arg1->value, arg2->value)));
}

// (tigrRGBA <number> <number> <number> <number>) -> <number>
static Obj *prim_tigrRGBA(void *root, Obj **env, Obj **list) {
    if (length(*list) != 4)
        error("Malformed tigrRGBA");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    Obj *arg2 = args->cdr->cdr->car;
    Obj *arg3 = args->cdr->cdr->cdr->car;
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    if (arg2->type != TNUMBER)
        error("Parameter #2 must be a number");
    if (arg3->type != TNUMBER)
        error("Parameter #3 must be a number");
    return make_number(root, packTPixel(tigrRGBA(arg0->value, arg1->value, arg2->value, arg3->value)));
}

// (tigrPrint <pointer> <pointer> <number> <number> <number> <string>) -> <void>
static Obj *prim_tigrPrint(void *root, Obj **env, Obj **list) {
    if (length(*list) != 6)
        error("Malformed tigrPrint");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    Obj *arg2 = args->cdr->cdr->car;
    Obj *arg3 = args->cdr->cdr->cdr->car;
    Obj *arg4 = args->cdr->cdr->cdr->cdr->car;
    Obj *arg5 = args->cdr->cdr->cdr->cdr->cdr->car;
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    if (arg1->type != TPOINTER)
        error("Parameter #1 must be a pointer");
    if (arg2->type != TNUMBER)
        error("Parameter #2 must be a number");
    if (arg3->type != TNUMBER)
        error("Parameter #3 must be a number");
    if (arg4->type != TNUMBER)
        error("Parameter #4 must be a number");
    if (arg5->type != TSTRING)
        error("Parameter #5 must be a string");
    tigrPrint(arg0->ptr, arg1->ptr, arg2->value, arg3->value, unpackTPixel(arg4->value), arg5->str);
    return Nil;
}

// (tfont) -> <pointer>
static Obj *prim_tfont(void *root, Obj **env, Obj **list) {
    return make_pointer(root, tfont);
}

// (tigrMouse <pointer>) -> <cell>
static Obj *prim_tigrMouse(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed tigrMouse");
    DEFINE2(tmp, cell);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    int x, y, b;
    tigrMouse(arg0->ptr, &x, &y, &b);
    *tmp = make_number(root, b);
    *cell = cons(root, tmp, &Nil);
    *tmp = make_number(root, y);
    *cell = cons(root, tmp, cell);
    *tmp = make_number(root, x);
    return cons(root, tmp, cell);
}

// (tigrKeyDown <pointer> <number>) -> <number>
static Obj *prim_tigrKeyDown(void *root, Obj **env, Obj **list) {
    if (length(*list) != 2)
        error("Malformed tigrKeyDown");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    if (arg1->type != TNUMBER)
        error("Parameter #1 must be a number");
    return make_number(root, tigrKeyDown(arg0->ptr, arg1->value));
}

// (tigrTime) -> <number>
static Obj *prim_tigrTime(void *root, Obj **env, Obj **list) {
    return make_number(root, tigrTime());
}

static void define_library(void *root, Obj **env) {
    add_primitive(root, env, "exit", prim_exit);
    add_primitive(root, env, "tigrWindow", prim_tigrWindow);
    add_primitive(root, env, "tigrFree", prim_tigrFree);
    add_primitive(root, env, "tigrClosed", prim_tigrClosed);
    add_primitive(root, env, "tigrUpdate", prim_tigrUpdate);
    add_primitive(root, env, "tigrClear", prim_tigrClear);
    add_primitive(root, env, "tigrLine", prim_tigrLine);
    add_primitive(root, env, "tigrCircle", prim_tigrCircle);
    add_primitive(root, env, "tigrFillCircle", prim_tigrFillCircle);
    add_primitive(root, env, "tigrRGB", prim_tigrRGB);
    add_primitive(root, env, "tigrRGBA", prim_tigrRGBA);
    add_primitive(root, env, "tigrPrint", prim_tigrPrint);
    add_primitive(root, env, "tfont", prim_tfont);
    add_primitive(root, env, "tigrMouse", prim_tigrMouse);
    add_primitive(root, env, "tigrKeyDown", prim_tigrKeyDown);
    add_primitive(root, env, "tigrTime", prim_tigrTime);
}

//======================================================================
// Entry point
//======================================================================

// Returns true if the environment variable is defined and not the empty string.
static bool getEnvFlag(char *name) {
    char *val = getenv(name);
    return val && val[0];
}

int main(int argc, char *argv[]) {
    // Debug flags
    debug_gc = getEnvFlag("MINILISP_DEBUG_GC");
    always_gc = getEnvFlag("MINILISP_ALWAYS_GC");
    bool prn = getEnvFlag("MINILISP_PRN");

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
    if (setjmp(exception_env) == 0) {
        // Set up the reader
        input = 1 < argc ? fopen(argv[1], "r") : stdin;
    } else {
        // Re-set up the reader
        input = stdin;
    }

    // The main loop
    return repl(root, env, prn || (input == stdin && isatty(STDIN_FILENO)));
}
