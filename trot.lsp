;;-------------------=={ TROT }==-----------------------------;;
;;                                                            ;;
;;  Rotate upside-down TEXT / MTEXT / ATTDEF by 180 degrees   ;;
;;  so it reads right-side up. Leaves text already between    ;;
;;  -90 and +90 untouched.                                    ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: TROT                                             ;;
;;  Args:    selection of TEXT/MTEXT/ATTDEF                   ;;
;;  Example: TROT -> select inverted labels -> all readable   ;;
;;------------------------------------------------------------;;

(defun c:TROT (/ ss n ent dxflist rot two-pi)
  (princ "\nSelect text to make right-side up: ")
  (setq ss (ssget '((0 . "TEXT,MTEXT,ATTDEF"))))
  (if ss
    (progn
      (setq two-pi (* 2 pi) n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              dxflist (entget ent)
              rot (cdr (assoc 50 dxflist)))
        (if rot
          (progn
            (setq rot (rem rot two-pi))
            (if (< rot 0) (setq rot (+ rot two-pi)))
            (if (and (> rot (/ pi 2)) (< rot (* 3 (/ pi 2))))
              (entmod (subst (cons 50 (- rot pi))
                             (assoc 50 dxflist) dxflist)))))
        (setq n (1+ n)))
      (princ (strcat "\nRotated " (itoa (sslength ss)) " text object(s)."))))
  (princ))
