;; CHZ - change the Z elevation of selected objects to a user-supplied value.
;; Command: CHZ

(defun c:CHZ (/ z ss n ent dxflist newlist)
  (setq z (getreal "\nNew Z elevation: "))
  (if z
    (progn
      (princ "\nSelect objects: ")
      (setq ss (ssget))
      (if ss
        (progn
          (setq n 0)
          (repeat (sslength ss)
            (setq ent (ssname ss n)
                  dxflist (entget ent))
            (setq newlist
                  (mapcar
                    (function
                      (lambda (pr / k v)
                        (setq k (car pr) v (cdr pr))
                        (cond
                          ((and (member k '(10 11 12 13))
                                (listp v) (= (length v) 3))
                           (cons k (list (car v) (cadr v) z)))
                          ((= k 38) (cons 38 z))
                          (T pr))))
                    dxflist))
            (entmod newlist)
            (setq n (1+ n)))
          (princ (strcat "\nMoved " (itoa (sslength ss)) " object(s) to Z="
                         (rtos z 2 4)))))))
  (princ))
