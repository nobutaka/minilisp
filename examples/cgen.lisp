(defun list (x . y)
  (cons x y))

(defun not (x)
  (if x () t))

(defun write-tree (text)
  (if text
      (if (not (listp text))
          (princ text)
        (write-tree (car text))
        (write-tree (cdr text)))))

;;;;;;;;;;

(defun def-prim ()
  (list
    "// (fopen <string> <string>)\n"
    "static Obj *prim_fopen(void *root, Obj **env, Obj **list) {\n"
    "    if (length(*list) != 2)\n"
    "        error(\"Malformed fopen\");\n"
    "    Obj *args = eval_list(root, env, list);\n"
    "    Obj *path = args->car;\n"
    "    Obj *mode = args->cdr->car;\n"
    "    if (path->type != TSTRING || mode->type != TSTRING)\n"
    "        error(\"Parameters must be strings\");\n"
    "    return make_pointer(root, fopen(path->str, mode->str));\n"
    "}\n"))

(defun add-prim (name)
  (list
    "    add_primitive(root, env, \"" name "\", prim_" name ");\n"))

(defun def-lib ()
  (list
    "static void define_library(void *root, Obj **env) {\n"
      (add-prim 'fopen)
    "}\n"))

;;;;;;;;;;

(write-tree (def-prim))
(princ "\n")
(write-tree (def-lib))
