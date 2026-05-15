;; SLP - compute and label slope between two picked 3D points.
;; Output: percent slope, ratio (H:V), and dv/dh values. Label placed at midpoint.
;; Use OSNAP to nodes/intersections on contours, vertices on profiles, etc.
;; Command: SLP

(defun c:SLP (/ p1 p2 dh dv slope-pct ratio mid lbl txth)
  (setq txth (getvar "TEXTSIZE"))
  (if (or (null txth) (<= txth 0)) (setq txth (getvar "DIMTXT")))
  (if (or (null txth) (<= txth 0)) (setq txth 1.0))
  (setq p1 (getpoint "\nPick first point: "))
  (if p1 (setq p2 (getpoint p1 "\nPick second point: ")))
  (if (and p1 p2)
    (progn
      (setq dh (distance (list (car p1) (cadr p1) 0.0)
                         (list (car p2) (cadr p2) 0.0))
            dv (- (caddr p2) (caddr p1))
            slope-pct (if (> dh 0.0) (* 100.0 (/ dv dh)) 0.0)
            ratio     (if (and (> dh 0.0) (/= dv 0.0))
                        (strcat (rtos (/ dh (abs dv)) 2 2) ":1")
                        "flat")
            mid (mapcar '(lambda (a b) (/ (+ a b) 2.0)) p1 p2)
            lbl (strcat (rtos slope-pct 2 2) "% (" ratio ")"))
      (entmake
        (list '(0 . "TEXT")
              (cons 10 mid)
              (cons 40 txth)
              (cons 1  lbl)
              (cons 11 mid)
              '(72 . 1) '(73 . 2)))
      (princ (strcat "\nSlope " lbl "   dv=" (rtos dv 2 3)
                     "   dh=" (rtos dh 2 3)))))
  (princ))
