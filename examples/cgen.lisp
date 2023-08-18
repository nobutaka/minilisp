(load "lib.lisp")

;;;;;;;;;;

(define nilables  '(                        (string? . string)      (pointer? . pointer)                  ))
(define ttypes    '((number  . TNUMBER)     (string  . TSTRING)     (pointer  . TPOINTER)     (nil . TNIL)))
(define ->values  '((number  . ->value)     (string  . ->str)       (pointer  . ->ptr)                    ))
(define make-objs '((number  . make_number) (string  . make_string) (pointer  . make_pointer)             ))

(defun nilablep (type)
  (assq type nilables))

(defun de-nilable (type)
  (let1 nilable (assq type nilables)
    (if nilable (cdr nilable) type)))

(defun ttype (type) (cdr (assq (de-nilable type) ttypes)))
(defun ->value (type) (cdr (assq (de-nilable type) ->values)))
(defun make-obj (type) (cdr (assq (de-nilable type) make-objs)))

;;;;;;;;;;

(defun c- (fname) (cons "c-" fname))
(defun c_ (fname) (cons "c_" fname))

(defun def-args (ptypes)
  (if (= (length ptypes) 1)
    (list "    DEFINE1(tmp);\n"
          "    *tmp = (*list)->car;\n"
          "    Obj *arg0 = eval(root, env, tmp);\n")
    (list "    Obj *args = eval_list(root, env, list);\n"
  (map (lambda (i)
    (list "    Obj *arg" i " = args" (map (lambda (_) "->cdr") (iota i)) "->car;\n")) (iota (length ptypes))))))

(defun %arg-type!= (i ptype)
  (list "arg" i "->type != " (ttype ptype)))

(defun arg-type!= (i ptype)
  (if (not (nilablep ptype))
      (%arg-type!= i ptype)
    (list (%arg-type!= i ptype) " && " (%arg-type!= i 'nil))))

(defun fargs (ptypes)
  (intersperse ", " (map-with-index (lambda (i ptype) (list "arg" i (->value ptype))) ptypes)))

(defun fcall (fname ptypes)
  (list fname "(" (fargs ptypes) ")"))

(defun def-prim (rtype fname ptypes)
  (list
    (list "// (" (c- fname) (map (lambda (ptype) (list " <" ptype ">")) ptypes) ")\n")
    (list "static Obj *prim_" (c_ fname) "(void *root, Obj **env, Obj **list) {\n")
  (if ptypes
    (list "    if (length(*list) != " (length ptypes) ")\n"
          "        error(\"Malformed " (c- fname) "\");\n"
               (def-args ptypes)))
  (map-with-index (lambda (i ptype)
    (list "    if (" (arg-type!= i ptype) ")\n"
          "        error(\"Parameter #" i " must be a " ptype "\");\n")) ptypes)
  (if (eq rtype 'void)
    (list "    " (fcall fname ptypes) ";\n"
          "    return Nil;\n")
    (list "    return " (make-obj rtype) "(root, " (fcall fname ptypes) ");\n"))
          "}\n\n"))

(defun add-prim (fname)
  (list "    add_primitive(root, env, \"" (c- fname) "\", prim_" (c_ fname) ");\n"))

(defun def-lib (fnames)
  (list
    "static void define_library(void *root, Obj **env) {\n"
      (map add-prim fnames)
    "}\n\n"))

;;;;;;;;;;

(define decls
  '((pointer? fopen string string)
    (number fclose pointer)
    (number putchar number)
    (void exit number)
    (void free pointer?)
    (number rand)
    (number sin number)))

(write-tree (map (lambda (decl) (def-prim (car decl) (cadr decl) (cddr decl))) decls))
(write-tree (def-lib (map cadr decls)))
