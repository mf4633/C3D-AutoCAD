;;-------------------=={ SLP }==------------------------------;;
;;                                                            ;;
;;  Compute and label slope between two picked 3D points.     ;;
;;  Output: percent slope, ratio (H:V), and dv/dh values.     ;;
;;  TEXT placed at midpoint. Use OSNAP to nodes on contours,  ;;
;;  vertices on profiles, points on a TIN, etc.               ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.1  -  2026-05-20                              ;;
;;  Command:  SLP                                             ;;
;;  Args:     pick two 3D points                              ;;
;;  Requires: _utils.lsp (c3d:txth)                           ;;
;;  Example:  SLP -> pick contour 100 -> pick contour 102     ;;
;;            label: "2.50% (40.00:1)"                        ;;
;;------------------------------------------------------------;;

(defun c:SLP (/ p1 p2 dh dv slope-pct ratio mid lbl txth)
  (setq txth (c3d:txth))
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
