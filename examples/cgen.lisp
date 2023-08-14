(defun list (x . y)
  (cons x y))

(defun not (x)
  (if x () t))

(defun map (fn lis)
  (if lis
      (cons (fn (car lis))
            (map fn (cdr lis)))))

(defun length (lis)
  (if lis
      (+ 1 (length (cdr lis)))
    0))

(defun join (sep lis)
  (if lis
      (cons (if (cdr lis)
                (cons (car lis) sep)
              (car lis))
            (join sep (cdr lis)))))

(defun %iota (m n)
  (if (< m n)
      (cons m (%iota (+ m 1) n))))

(defun iota (n)
  (%iota 0 n))

(defun write-tree (text)
  (if text
      (if (not (listp text))
          (princ text)
        (write-tree (car text))
        (write-tree (cdr text)))))

;;;;;;;;;;

(defun def-prim (name params)
  (list
    (list "// (" name (map (lambda (param) (list " <" param ">")) params) ")\n")
    (list "static Obj *prim_" name "(void *root, Obj **env, Obj **list) {\n")
    (list "    if (length(*list) != " (length params) ")\n")
    (list "        error(\"Malformed " name "\");\n")
          "    Obj *args = eval_list(root, env, list);\n"
    (map (lambda (i)
    (list "    Obj *arg" i " = args->car;\n")) (iota (length params)))
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

(define decls
  '((fopen string string)
    (fclose pointer)))

(write-tree (map (lambda (decl) (def-prim (car decl) (cdr decl))) decls))
(write-tree (def-lib (map car decls)))
