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

(defun genadd (fname)
  (list "add_primitive(root, env, \"" fname "\", prim_" fname ");\n"))

(write-tree (genadd 'fopen))
(write-tree (genadd 'fclose))
