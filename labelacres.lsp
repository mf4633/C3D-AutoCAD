;; LABELACRES - label closed polylines, hatches, circles, ellipses, regions
;; with area in acres to 0.1 ac. Label is MTEXT at the bounding-box center.
;; Command: LABELACRES

(defun bbcenter (obj / minp maxp)
  (vla-GetBoundingBox obj 'minp 'maxp)
  (mapcar '(lambda (a b) (/ (+ a b) 2.0))
          (vlax-safearray->list minp)
          (vlax-safearray->list maxp)))

(defun c:LABELACRES (/ ss n ent obj nm area-sf area-ac center label txth count)
  (vl-load-com)
  (setq txth (getvar "TEXTSIZE"))
  (if (or (null txth) (<= txth 0)) (setq txth (getvar "DIMTXT")))
  (if (or (null txth) (<= txth 0)) (setq txth 1.0))
  (princ "\nSelect closed polylines/hatches/circles/ellipses/regions: ")
  (setq ss (ssget '((0 . "LWPOLYLINE,POLYLINE,HATCH,CIRCLE,ELLIPSE,REGION,SPLINE"))))
  (setq count 0)
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
            (setq area-sf (vla-get-Area obj)
                  area-ac (/ area-sf 43560.0)
                  center  (bbcenter obj)
                  label   (strcat (rtos area-ac 2 1) " AC"))
            (entmake
              (list
                '(0 . "MTEXT")
                '(100 . "AcDbEntity")
                '(100 . "AcDbMText")
                (cons 10 center)
                (cons 40 txth)
                (cons 1 label)
                '(71 . 5)))
            (setq count (1+ count))))
        (setq n (1+ n)))
      (princ (strcat "\nLabeled " (itoa count) " object(s) in acres."))))
  (princ))
