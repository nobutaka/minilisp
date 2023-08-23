#include "minilisp.c"
#include <math.h>

//======================================================================
// C library functions
//======================================================================

// (fopen <string> <string>) -> <pointer?>
static Obj *prim_fopen(void *root, Obj **env, Obj **list) {
    if (length(*list) != 2)
        error("Malformed fopen");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    if (arg0->type != TSTRING)
        error("Parameter #0 must be a string");
    if (arg1->type != TSTRING)
        error("Parameter #1 must be a string");
    return make_pointer(root, fopen(arg0->str, arg1->str));
}

// (fclose <pointer>) -> <number>
static Obj *prim_fclose(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed fclose");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    return make_number(root, fclose(arg0->ptr));
}

// (putchar <number>) -> <number>
static Obj *prim_putchar(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed putchar");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    return make_number(root, putchar(arg0->value));
}

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

// (free <pointer?>) -> <void>
static Obj *prim_free(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed free");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER && arg0->type != TNIL)
        error("Parameter #0 must be a pointer?");
    free(arg0->ptr);
    return Nil;
}

// (rand) -> <number>
static Obj *prim_rand(void *root, Obj **env, Obj **list) {
    return make_number(root, rand());
}

// (sin <number>) -> <number>
static Obj *prim_sin(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed sin");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    return make_number(root, sin(arg0->value));
}

static void define_library(void *root, Obj **env) {
    add_primitive(root, env, "fopen", prim_fopen);
    add_primitive(root, env, "fclose", prim_fclose);
    add_primitive(root, env, "putchar", prim_putchar);
    add_primitive(root, env, "exit", prim_exit);
    add_primitive(root, env, "free", prim_free);
    add_primitive(root, env, "rand", prim_rand);
    add_primitive(root, env, "sin", prim_sin);
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
    return repl(root, env, prn || input == stdin && isatty(STDIN_FILENO));
}
