(defun caar (x) (car (car x)))
(defun cadr (x) (car (cdr x)))
(defun cdar (x) (cdr (car x)))
(defun cddr (x) (cdr (cdr x)))
(defun caddr (x) (car (cdr (cdr x))))

(defun list (x . y)
  (cons x y))

(defun not (x)
  (if x () t))

(defmacro let1 (var val . body)
  (cons (cons 'lambda (cons (list var) body)) (list val)))

(defmacro aif (test then . else)
  (list 'let1 'it test
    (cons 'if (cons 'it (cons then else)))))

(defmacro and (expr . rest)
  (if rest
      (list 'if expr (cons 'and rest))
    expr))

(defmacro or (expr . rest)
  (if rest
      (let1 var (gensym)
        (list 'let1 var expr
          (list 'if var var (cons 'or rest))))
    expr))

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

(defun %reverse (lis ret)
  (if lis
      (%reverse (cdr lis) (cons (car lis) ret))
    ret))

(defun reverse (lis)
  (%reverse lis ()))

(defun %intersperse (sep lis ret)
  (if lis
      (%intersperse sep (cdr lis) (if (cdr lis)
                                      (cons sep (cons (car lis) ret))
                                    (cons (car lis) ret)))
    (reverse ret)))

(defun intersperse (sep lis)
  (%intersperse sep lis ()))

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
