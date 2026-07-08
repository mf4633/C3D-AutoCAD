;;-------------------=={ TLEN }==-----------------------------;;
;;                                                            ;;
;;  Report the total length of selected lines / polylines /   ;;
;;  arcs / circles / ellipses / splines. Output in drawing    ;;
;;  units (ft) and miles.                                     ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.2  -  2026-07-07                               ;;
;;  Command: TLEN                                             ;;
;;  Args:    selection of linear entities                     ;;
;;  Example: TLEN -> select pipe runs -> "1234.56 (0.234 mi)" ;;
;;------------------------------------------------------------;;

(defun c:TLEN (/ ss n ent len total)
  (vl-load-com)
  (setq total 0.0)
  (princ "\nSelect linear objects: ")
  (setq ss (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE,ARC,CIRCLE,ELLIPSE,SPLINE"))))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              ;; vlax-curve-getDistAtParam over the full param range returns the
              ;; true length of ANY curve type (line, arc, circle, ellipse,
              ;; spline, polyline). The old VLA-property probe silently dropped
              ;; ELLIPSE and SPLINE, which expose no Length/ArcLength property.
              len (vl-catch-all-apply
                    '(lambda ()
                       (vlax-curve-getDistAtParam
                         ent (vlax-curve-getEndParam ent)))))
        (if (and len (not (vl-catch-all-error-p len)))
          (setq total (+ total len)))
        (setq n (1+ n)))
      (princ (strcat "\nTotal length: " (rtos total 2 2)
                     " (" (rtos (/ total 5280.0) 2 3) " mi)"))))
  (princ))
