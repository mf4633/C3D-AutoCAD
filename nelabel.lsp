;;-------------------=={ NE }==-------------------------------;;
;;                                                            ;;
;;  Place a N/E coordinate label at picked points (repeating  ;;
;;  until Enter). Label is MText:                             ;;
;;     N nnnn.nn                                              ;;
;;     E eeee.ee                                              ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.1  -  2026-05-20                              ;;
;;  Command:  NE                                              ;;
;;  Args:     pick points, Enter to quit                      ;;
;;  Requires: _utils.lsp (c3d:txth)                           ;;
;;  Example:  NE -> pick corner -> "N 12345.67\\PE 7890.12"   ;;
;;------------------------------------------------------------;;

(defun c:NE (/ p lbl txth)
  (setq txth (c3d:txth))
  (while (setq p (getpoint "\nPick point (Enter to quit): "))
    (setq lbl (strcat "N " (rtos (cadr p) 2 2)
                      "\\PE " (rtos (car p) 2 2)))
    (entmake
      (list '(0 . "MTEXT")
            '(100 . "AcDbEntity") '(100 . "AcDbMText")
            (cons 10 p)
            (cons 40 txth)
            (cons 1  lbl)
            '(71 . 7))))
  (princ))
