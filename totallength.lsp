;;-------------------=={ TLEN }==-----------------------------;;
;;                                                            ;;
;;  Report the total length of selected lines / polylines /   ;;
;;  arcs / circles / ellipses / splines. Output in drawing    ;;
;;  units (ft) and miles.                                     ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: TLEN                                             ;;
;;  Args:    selection of linear entities                     ;;
;;  Example: TLEN -> select pipe runs -> "1234.56 (0.234 mi)" ;;
;;------------------------------------------------------------;;

(defun c:TLEN (/ ss n ent obj total)
  (vl-load-com)
  (setq total 0.0)
  (princ "\nSelect linear objects: ")
  (setq ss (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE,ARC,CIRCLE,ELLIPSE,SPLINE"))))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              obj (vlax-ename->vla-object ent))
        (cond
          ((vlax-property-available-p obj 'Length)
           (setq total (+ total (vla-get-Length obj))))
          ((vlax-property-available-p obj 'Circumference)
           (setq total (+ total (vla-get-Circumference obj))))
          ((vlax-property-available-p obj 'ArcLength)
           (setq total (+ total (vla-get-ArcLength obj)))))
        (setq n (1+ n)))
      (princ (strcat "\nTotal length: " (rtos total 2 2)
                     " (" (rtos (/ total 5280.0) 2 3) " mi)"))))
  (princ))
