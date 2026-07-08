;;-------------------=={ MAKELOWER }==------------------------;;
;;                                                            ;;
;;  Convert selected TEXT / MTEXT to lowercase. Pairs with    ;;
;;  MAKEUPPER and TITLECASE.                                  ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.2  -  2026-07-07                              ;;
;;  Command:  MAKELOWER                                       ;;
;;  Args:     selection of TEXT/MTEXT, or Enter for ALL       ;;
;;  Requires: _utils.lsp (c3d:mtext-case)                     ;;
;;  Example:  MAKELOWER -> Enter -> all drawing text lowercase;;
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
        ;; MTEXT carries inline format codes; fold only its visible text.
        (if (= (vla-get-ObjectName obj) "AcDbMText")
          (vla-put-TextString obj (c3d:mtext-case (vla-get-TextString obj) 'lower))
          (vla-put-TextString obj (strcase (vla-get-TextString obj) T)))
        (setq n (1+ n)))
      (princ (strcat "\nLowercased " (itoa (sslength ss)) " text object(s)."))))
  (princ))
