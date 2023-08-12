(defun list (x . y)
  (cons x y))

(defun not (x)
  (if x () t))

(defun map (fn lis)
  (if lis
      (cons (fn (car lis))
            (map fn (cdr lis)))))

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
          "}\n\n"))

(defun add-prim (name)
  (list "    add_primitive(root, env, \"" name "\", prim_" name ");\n"))

(defun def-lib (names)
  (list
    "static void define_library(void *root, Obj **env) {\n"
      (map add-prim names)
    "}\n\n"))

;;;;;;;;;;

(define names '(fopen fclose))

(write-tree (map def-prim names))
(write-tree (def-lib names))
