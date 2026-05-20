;;-------------------=={ MAKELOWER }==------------------------;;
;;                                                            ;;
;;  Convert selected TEXT / MTEXT to lowercase. Pairs with    ;;
;;  MAKEUPPER and TITLECASE.                                  ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: MAKELOWER                                        ;;
;;  Args:    selection of TEXT/MTEXT, or Enter for ALL        ;;
;;  Example: MAKELOWER -> Enter -> all drawing text lowercase ;;
;;------------------------------------------------------------;;

(defun c:MAKELOWER (/ ss n ent obj)
  (vl-load-com)
  (princ "\nSelect TEXT/MTEXT to lowercase (Enter for ALL): ")
  (setq ss (ssget '((0 . "TEXT,MTEXT"))))
  (if (null ss) (setq ss (ssget "X" '((0 . "TEXT,MTEXT")))))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              obj (vlax-ename->vla-object ent))
        (vla-put-TextString obj (strcase (vla-get-TextString obj) T))
        (setq n (1+ n)))
      (princ (strcat "\nLowercased " (itoa (sslength ss)) " text object(s)."))))
  (princ))
