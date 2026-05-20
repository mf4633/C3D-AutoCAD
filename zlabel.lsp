;;-------------------=={ ZL }==-------------------------------;;
;;                                                            ;;
;;  Place an elevation (Z) label at picked points (repeating  ;;
;;  until Enter). Use OSNAP set to Endpoint / Insertion on a  ;;
;;  TIN, contours, or 3D survey points.                       ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.1  -  2026-05-20                              ;;
;;  Command:  ZL                                              ;;
;;  Args:     pick 3D points, Enter to quit                   ;;
;;  Requires: _utils.lsp (c3d:txth)                           ;;
;;  Example:  ZL -> snap to contour -> "EL 1023.45"           ;;
;;------------------------------------------------------------;;

(defun c:ZL (/ p lbl txth)
  (setq txth (c3d:txth))
  (while (setq p (getpoint "\nPick point with elevation (Enter to quit): "))
    (setq lbl (strcat "EL " (rtos (caddr p) 2 2)))
    (entmake
      (list '(0 . "TEXT")
            (cons 10 p)
            (cons 40 txth)
            (cons 1  lbl))))
  (princ))
