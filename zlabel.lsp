;; ZL - place an elevation (Z) label at picked points (repeating).
;; Useful with OSNAP set to Endpoint/Insertion on a TIN, contours, or 3D points.
;; Command: ZL

(defun c:ZL (/ p lbl txth)
  (setq txth (getvar "TEXTSIZE"))
  (if (or (null txth) (<= txth 0)) (setq txth (getvar "DIMTXT")))
  (if (or (null txth) (<= txth 0)) (setq txth 1.0))
  (while (setq p (getpoint "\nPick point with elevation (Enter to quit): "))
    (setq lbl (strcat "EL " (rtos (caddr p) 2 2)))
    (entmake
      (list '(0 . "TEXT")
            (cons 10 p)
            (cons 40 txth)
            (cons 1  lbl))))
  (princ))
