;; CENTROID - place a POINT at the bounding-box center of a picked closed
;; polyline / hatch / circle / ellipse / region. Useful for labels and pivots.
;; Command: CENTROID

(defun bbcenter (obj / minp maxp)
  (vla-GetBoundingBox obj 'minp 'maxp)
  (mapcar '(lambda (a b) (/ (+ a b) 2.0))
          (vlax-safearray->list minp)
          (vlax-safearray->list maxp)))

(defun c:CENTROID (/ ent obj cen)
  (vl-load-com)
  (setq ent (car (entsel "\nPick closed polyline / hatch / circle / region: ")))
  (if ent
    (progn
      (setq obj (vlax-ename->vla-object ent)
            cen (bbcenter obj))
      (entmake (list '(0 . "POINT") (cons 10 cen)))
      (princ (strcat "\nCentroid at "
                     (rtos (car cen) 2 4) ", "
                     (rtos (cadr cen) 2 4)))))
  (princ))
