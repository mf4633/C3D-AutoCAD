;;-------------------=={ CENTROID }==-------------------------;;
;;                                                            ;;
;;  Place a POINT at the bounding-box center of a picked      ;;
;;  closed polyline / hatch / circle / ellipse / region.      ;;
;;  Useful as a label anchor or block pivot.                  ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.1  -  2026-05-20                              ;;
;;  Command:  CENTROID                                        ;;
;;  Args:     pick one closed entity                          ;;
;;  Requires: _utils.lsp (c3d:bbcenter)                       ;;
;;  Example:  CENTROID -> pick polygon -> POINT at bbox ctr   ;;
;;------------------------------------------------------------;;

(defun c:CENTROID (/ ent obj cen)
  (vl-load-com)
  (setq ent (car (entsel "\nPick closed polyline / hatch / circle / region: ")))
  (if ent
    (progn
      (setq obj (vlax-ename->vla-object ent)
            cen (c3d:bbcenter obj))
      (entmake (list '(0 . "POINT") (cons 10 cen)))
      (princ (strcat "\nCentroid at "
                     (rtos (car cen) 2 4) ", "
                     (rtos (cadr cen) 2 4)))))
  (princ))
