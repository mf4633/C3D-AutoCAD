;;-------------------=={ SCALETXT }==-------------------------;;
;;                                                            ;;
;;  Scale every selected TEXT / MTEXT / ATTDEF by a factor    ;;
;;  WITHOUT moving the insertion point. Unlike the SCALE      ;;
;;  command (which scales position too), this only changes    ;;
;;  text height — labels stay where they are.                 ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.0  -  2026-05-20                               ;;
;;  Command: SCALETXT                                         ;;
;;  Args:    scale factor, then selection                     ;;
;;  Example: SCALETXT -> 2.0 -> all picked labels twice tall  ;;
;;------------------------------------------------------------;;

(defun c:SCALETXT (/ sf ss n ent edata h newdata)
  (setq sf (getreal "\nScale factor: "))
  (if (and sf (> sf 0.0))
    (progn
      (princ "\nSelect text: ")
      (setq ss (ssget '((0 . "TEXT,MTEXT,ATTDEF"))))
      (if ss
        (progn
          (setq n 0)
          (repeat (sslength ss)
            (setq ent     (ssname ss n)
                  edata   (entget ent)
                  h       (cdr (assoc 40 edata))
                  newdata (subst (cons 40 (* h sf)) (assoc 40 edata) edata))
            (entmod newdata)
            (setq n (1+ n)))
          (princ (strcat "\nScaled " (itoa (sslength ss)) " text object(s) by "
                         (rtos sf 2 3))))))
    (princ "\nInvalid factor; nothing changed."))
  (princ))
