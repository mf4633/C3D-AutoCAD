;;-------------------=={ CTH }==------------------------------;;
;;                                                            ;;
;;  Change the text height of every selected TEXT / MTEXT /   ;;
;;  ATTDEF to a user-supplied value.                          ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: CTH                                              ;;
;;  Args:    new height, then selection                       ;;
;;  Example: CTH -> 0.10 -> select labels -> all 0.10 tall    ;;
;;------------------------------------------------------------;;

(defun c:CTH (/ ht ss n ent edata)
  (setq ht (getreal "\nNew text height: "))
  (if (and ht (> ht 0.0))
    (progn
      (princ "\nSelect text: ")
      (setq ss (ssget '((0 . "TEXT,MTEXT,ATTDEF"))))
      (if ss
        (progn
          (setq n 0)
          (repeat (sslength ss)
            (setq ent (ssname ss n)
                  edata (entget ent))
            (entmod (subst (cons 40 ht) (assoc 40 edata) edata))
            (setq n (1+ n)))
          (princ (strcat "\nSet height " (rtos ht 2 4) " on "
                         (itoa (sslength ss)) " text object(s).")))))
    (princ "\nInvalid height; nothing changed."))
  (princ))
