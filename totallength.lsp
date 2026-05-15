;; TLEN - report total length of selected lines/polylines/arcs/circles/etc.
;; Output in drawing units (ft) and miles.
;; Command: TLEN

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
