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
