(defun caar (x) (car (car x)))
(defun cadr (x) (car (cdr x)))
(defun cdar (x) (cdr (car x)))
(defun cddr (x) (cdr (cdr x)))

(defun list (x . y)
  (cons x y))

(defun not (x)
  (if x () t))

(defun map (fn lis)
  (if lis
      (cons (fn (car lis))
            (map fn (cdr lis)))))

(defun map2 (fn lis1 lis2)
  (if lis1
      (if lis2
          (cons (fn (car lis1) (car lis2))
                (map2 fn (cdr lis1) (cdr lis2))))))

(defun map-with-index (fn lis)
  (map2 fn (iota (length lis)) lis))

(defun assq (x lis)
  (if lis
      (if (eq x (caar lis))
          (car lis)
        (assq x (cdr lis)))))

(defun length (lis)
  (if lis
      (+ 1 (length (cdr lis)))
    0))

(defun intersperse (sep lis)
  (if lis
      (cons (if (cdr lis)
                (cons (car lis) sep)
              (car lis))
            (intersperse sep (cdr lis)))))

(defun %iota (m n)
  (if (< m n)
      (cons m (%iota (+ m 1) n))))

(defun iota (n)
  (%iota 0 n))

(defun write-tree (x)
  (if x
      (if (not (listp x))
          (princ x)
        (write-tree (car x))
        (write-tree (cdr x)))))

;;;;;;;;;;

(define ttypes    '((number . TNUMBER)     (string . TSTRING)     (pointer . TPOINTER)))
(define ->values  '((number . ->value)     (string . ->str)       (pointer . ->ptr)))
(define make-objs '((number . make_number) (string . make_string) (pointer . make_pointer)))

(defun fargs (ptypes)
  (intersperse ", " (map-with-index (lambda (i ptype) (list "arg" i (cdr (assq ptype ->values)))) ptypes)))

(defun def-prim (rtype fname ptypes)
  (list
    (list "// (" fname (map (lambda (ptype) (list " <" ptype ">")) ptypes) ")\n")
    (list "static Obj *prim_" fname "(void *root, Obj **env, Obj **list) {\n")
    (list "    if (length(*list) != " (length ptypes) ")\n")
    (list "        error(\"Malformed " fname "\");\n")
          "    Obj *args = eval_list(root, env, list);\n"
    (map (lambda (i)
    (list "    Obj *arg" i " = args" (map (lambda (_) "->cdr") (iota i)) "->car;\n")) (iota (length ptypes)))
    (map-with-index (lambda (i ptype)
    (list "    if (arg" i "->type != " (cdr (assq ptype ttypes)) ")\n"
          "        error(\"Parameter #" i " must be a " ptype "\");\n")) ptypes)
    (list "    return " (cdr (assq rtype make-objs)) "(root, " fname "(" (fargs ptypes) "));\n")
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
    (number fclose pointer)))

(write-tree (map (lambda (decl) (def-prim (car decl) (cadr decl) (cddr decl))) decls))
(write-tree (def-lib (map cadr decls)))
