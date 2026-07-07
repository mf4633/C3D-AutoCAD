;;-------------------=={ MAKEUPPER }==------------------------;;
;;                                                            ;;
;;  Convert selected TEXT / MTEXT / ATTDEF to UPPERCASE.      ;;
;;  Pairs with MAKELOWER and TITLECASE.                       ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.2  -  2026-07-07                              ;;
;;  Command:  MAKEUPPER                                       ;;
;;  Args:     selection of TEXT/MTEXT/ATTDEF, or Enter for ALL;;
;;  Requires: _utils.lsp (c3d:mtext-case)                     ;;
;;  Example:  MAKEUPPER -> Enter -> all drawing text UPPERCASE;;
;;  Fixes:    v1.0 filter included invalid DTEXT and was      ;;
;;            always-all; v1.2 preserves MTEXT format codes.  ;;
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
        ;; MTEXT carries inline format codes; fold only its visible text.
        (if (= (vla-get-ObjectName obj) "AcDbMText")
          (vla-put-TextString obj (c3d:mtext-case (vla-get-TextString obj) 'upper))
          (vla-put-TextString obj (strcase (vla-get-TextString obj))))
        (setq n (1+ n)))
      (princ (strcat "\nUppercased " (itoa (sslength ss)) " text object(s)."))))
  (princ))
