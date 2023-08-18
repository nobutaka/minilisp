#define MINILISP_EXT
#include "minilisp.c"

#include <math.h>

//======================================================================
// C library functions
//======================================================================

// (c-fopen <string> <string>)
static Obj *prim_c_fopen(void *root, Obj **env, Obj **list) {
    if (length(*list) != 2)
        error("Malformed c-fopen");
    Obj *args = eval_list(root, env, list);
    Obj *arg0 = args->car;
    Obj *arg1 = args->cdr->car;
    if (arg0->type != TSTRING)
        error("Parameter #0 must be a string");
    if (arg1->type != TSTRING)
        error("Parameter #1 must be a string");
    return make_pointer(root, fopen(arg0->str, arg1->str));
}

// (c-fclose <pointer>)
static Obj *prim_c_fclose(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed c-fclose");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER)
        error("Parameter #0 must be a pointer");
    return make_number(root, fclose(arg0->ptr));
}

// (c-putchar <number>)
static Obj *prim_c_putchar(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed c-putchar");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    return make_number(root, putchar(arg0->value));
}

// (c-exit <number>)
static Obj *prim_c_exit(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed c-exit");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    exit(arg0->value);
    return Nil;
}

// (c-free <pointer?>)
static Obj *prim_c_free(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed c-free");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TPOINTER && arg0->type != TNIL)
        error("Parameter #0 must be a pointer?");
    free(arg0->ptr);
    return Nil;
}

// (c-rand)
static Obj *prim_c_rand(void *root, Obj **env, Obj **list) {
    return make_number(root, rand());
}

// (c-sin <number>)
static Obj *prim_c_sin(void *root, Obj **env, Obj **list) {
    if (length(*list) != 1)
        error("Malformed c-sin");
    DEFINE1(tmp);
    *tmp = (*list)->car;
    Obj *arg0 = eval(root, env, tmp);
    if (arg0->type != TNUMBER)
        error("Parameter #0 must be a number");
    return make_number(root, sin(arg0->value));
}

static void define_library(void *root, Obj **env) {
    add_primitive(root, env, "c-fopen", prim_c_fopen);
    add_primitive(root, env, "c-fclose", prim_c_fclose);
    add_primitive(root, env, "c-putchar", prim_c_putchar);
    add_primitive(root, env, "c-exit", prim_c_exit);
    add_primitive(root, env, "c-free", prim_c_free);
    add_primitive(root, env, "c-rand", prim_c_rand);
    add_primitive(root, env, "c-sin", prim_c_sin);
}
