(defun map (lis fn)
  (if lis
    (cons (fn (car lis))
	  (map (cdr lis) fn))))

(defun princl (a . rest)
  (map (cons a rest) princ))

(defun genadd (fname)
  (princl "add_primitive(root, env, \"" fname "\", prim_" fname ");\n"))

(genadd 'fopen)
(genadd 'fclose)
