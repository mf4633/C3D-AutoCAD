;;-------------------=={ CHZ }==------------------------------;;
;;                                                            ;;
;;  Change the Z elevation of selected objects to a           ;;
;;  user-supplied value. Operates on DXF groups 10/11/12/13   ;;
;;  for 3D point lists plus DXF 38 for LWPOLYLINE elevation.  ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: CHZ                                              ;;
;;  Args:    new Z value, then selection                      ;;
;;  Example: CHZ -> 1023.5 -> select EOP polylines            ;;
;;------------------------------------------------------------;;

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
