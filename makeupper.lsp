;;-------------------=={ MAKEUPPER }==------------------------;;
;;                                                            ;;
;;  Convert selected TEXT / MTEXT / ATTDEF to UPPERCASE.      ;;
;;  Pairs with MAKELOWER and TITLECASE.                       ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: MAKEUPPER                                        ;;
;;  Args:    selection of TEXT/MTEXT/ATTDEF, or Enter for ALL ;;
;;  Example: MAKEUPPER -> Enter -> all drawing text UPPERCASE ;;
;;  Fixes:   v1.0 filter included invalid DTEXT and was       ;;
;;           always-all with no selection prompt.             ;;
;;------------------------------------------------------------;;

(defun c:MAKEUPPER (/ ss n ent obj)
  (vl-load-com)
  (princ "\nSelect TEXT/MTEXT/ATTDEF to UPPERCASE (Enter for ALL): ")
  (setq ss (ssget '((0 . "TEXT,MTEXT,ATTDEF"))))
  (if (null ss) (setq ss (ssget "X" '((0 . "TEXT,MTEXT,ATTDEF")))))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              obj (vlax-ename->vla-object ent))
        (vla-put-TextString obj (strcase (vla-get-TextString obj)))
        (setq n (1+ n)))
      (princ (strcat "\nUppercased " (itoa (sslength ss)) " text object(s)."))))
  (princ))
