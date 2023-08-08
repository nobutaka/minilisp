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

(define tab "    ")

(defun add-prim (name)
  (list tab "add_primitive(root, env, \"" name "\", prim_" name ");\n"))

(write-tree (add-prim 'fopen))
(write-tree (add-prim 'fclose))
