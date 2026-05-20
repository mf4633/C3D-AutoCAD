;;-------------------=={ GETZ }==-----------------------------;;
;;                                                            ;;
;;  Report the Z elevation of a picked object. Uses DXF 38    ;;
;;  for LWPOLYLINE; otherwise the Z of the insertion point    ;;
;;  (DXF 10).                                                 ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: GETZ                                             ;;
;;  Args:    pick one object                                  ;;
;;  Example: GETZ -> pick contour -> "LWPOLYLINE Z = 1023.50" ;;
;;------------------------------------------------------------;;

(defun c:GETZ (/ ent edata typ elv p10)
  (setq ent (car (entsel "\nPick object: ")))
  (if ent
    (progn
      (setq edata (entget ent)
            typ   (cdr (assoc 0 edata))
            elv   (cdr (assoc 38 edata))
            p10   (cdr (assoc 10 edata)))
      (cond
        ((and elv (member typ '("LWPOLYLINE")))
         (princ (strcat "\n" typ " elevation (DXF 38) = " (rtos elv 2 4))))
        ((and p10 (= (length p10) 3))
         (princ (strcat "\n" typ " Z = " (rtos (caddr p10) 2 4))))
        (T (princ (strcat "\nNo Z information available for " typ))))))
  (princ))
