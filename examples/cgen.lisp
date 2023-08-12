(defun list (x . y)
  (cons x y))

(defun not (x)
  (if x () t))

(defun map (lis fn)
  (if lis
      (cons (fn (car lis))
            (map (cdr lis) fn))))

(defun write-tree (text)
  (if text
      (if (not (listp text))
          (princ text)
        (write-tree (car text))
        (write-tree (cdr text)))))

;;;;;;;;;;

(defun def-prim (name)
  (list
    (list "// (" name " <string> <string>)\n")
    (list "static Obj *prim_" name "(void *root, Obj **env, Obj **list) {\n")
          "    if (length(*list) != 2)\n"
    (list "        error(\"Malformed " name "\");\n")
          "    Obj *args = eval_list(root, env, list);\n"
          "    Obj *path = args->car;\n"
          "    Obj *mode = args->cdr->car;\n"
          "    if (path->type != TSTRING || mode->type != TSTRING)\n"
          "        error(\"Parameters must be strings\");\n"
    (list "    return make_pointer(root, " name "(path->str, mode->str));\n")
          "}\n"))

(defun add-prim (name)
  (list "    add_primitive(root, env, \"" name "\", prim_" name ");\n"))

(defun def-lib ()
  (list
    "static void define_library(void *root, Obj **env) {\n"
      (add-prim 'fopen)
    "}\n"))

;;;;;;;;;;

(write-tree (def-prim 'fopen))
(princ "\n")
(write-tree (def-lib))
