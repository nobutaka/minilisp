#define MINILISP_EXT
#include "minilisp.c"

#include <math.h>

//======================================================================
// C library functions
//======================================================================

// (fopen <string> <string>)
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

// (fclose <pointer>)
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

// (putchar <number>)
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

// (exit <number>)
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

// (rand)
static Obj *prim_rand(void *root, Obj **env, Obj **list) {
    return make_number(root, rand());
}

// (sin <number>)
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
    add_primitive(root, env, "rand", prim_rand);
    add_primitive(root, env, "sin", prim_sin);
}
