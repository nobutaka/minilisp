(load "lib.lisp")

;;;;;;;;;;

(define ttypes    '((number . TNUMBER)     (string . TSTRING)     (pointer . TPOINTER)     (nil . TNIL)))
(define ->values  '((number . ->value)     (string . ->str)       (pointer . ->ptr)                    ))
(define make-objs '((number . make_number) (string . make_string) (pointer . make_pointer)             ))

(defun %type!= (i ptype)
  (list "arg" i "->type != " (cdr (assq ptype ttypes))))

(defun type!= (i ptype)
  (if (eq ptype 'number)
      (%type!= i ptype)
    (list (%type!= i ptype) " && " (%type!= i 'nil))))

(defun fargs (ptypes)
  (intersperse ", " (map-with-index (lambda (i ptype) (list "arg" i (cdr (assq ptype ->values)))) ptypes)))

(defun fcall (fname ptypes)
  (list fname "(" (fargs ptypes) ")"))

(defun def-prim (rtype fname ptypes)
  (list
    (list "// (" fname (map (lambda (ptype) (list " <" ptype ">")) ptypes) ")\n")
    (list "static Obj *prim_" fname "(void *root, Obj **env, Obj **list) {\n")
  (if ptypes
    (list "    if (length(*list) != " (length ptypes) ")\n"
          "        error(\"Malformed " fname "\");\n"
          "    Obj *args = eval_list(root, env, list);\n"))
  (map (lambda (i)
    (list "    Obj *arg" i " = args" (map (lambda (_) "->cdr") (iota i)) "->car;\n")) (iota (length ptypes)))
  (map-with-index (lambda (i ptype)
    (list "    if (" (type!= i ptype) ")\n"
          "        error(\"Parameter #" i " must be a " ptype "\");\n")) ptypes)
  (if (eq rtype 'void)
    (list "    " (fcall fname ptypes) ";\n"
          "    return Nil;\n")
    (list "    return " (cdr (assq rtype make-objs)) "(root, " (fcall fname ptypes) ");\n"))
          "}\n\n"))

(defun add-prim (fname)
  (list "    add_primitive(root, env, \"" fname "\", prim_" fname ");\n"))

(defun def-lib (fnames)
  (list
    "static void define_library(void *root, Obj **env) {\n"
      (map add-prim fnames)
    "}\n\n"))

;;;;;;;;;;

(define decls
  '((pointer fopen string string)
    (number fclose pointer)
    (number putchar number)
    (void exit number)
    (number rand)
    (number sin number)))

(write-tree (map (lambda (decl) (def-prim (car decl) (cadr decl) (cddr decl))) decls))
(write-tree (def-lib (map cadr decls)))
