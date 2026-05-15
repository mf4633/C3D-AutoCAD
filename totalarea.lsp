;; TOTALAREA - sum the area of selected closed entities.
;; Reports total in sq ft and acres at the command line.
;; Command: TOTALAREA

(defun c:TOTALAREA (/ ss n ent obj nm total-sf total-ac count)
  (vl-load-com)
  (setq total-sf 0.0 count 0)
  (princ "\nSelect closed polylines/hatches/circles/ellipses/regions: ")
  (setq ss (ssget '((0 . "LWPOLYLINE,POLYLINE,HATCH,CIRCLE,ELLIPSE,REGION,SPLINE"))))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              obj (vlax-ename->vla-object ent)
              nm  (vla-get-ObjectName obj))
        (if (or (= nm "AcDbHatch")
                (= nm "AcDbCircle")
                (= nm "AcDbEllipse")
                (= nm "AcDbRegion")
                (and (vlax-property-available-p obj 'Closed)
                     (= (vla-get-Closed obj) :vlax-true)))
          (progn
            (setq total-sf (+ total-sf (vla-get-Area obj))
                  count    (1+ count))))
        (setq n (1+ n)))
      (setq total-ac (/ total-sf 43560.0))
      (princ (strcat "\nCounted: " (itoa count)
                     "   Total = " (rtos total-sf 2 2) " sq ft   /   "
                     (rtos total-ac 2 3) " acres"))))
  (princ))
