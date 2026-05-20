;;-------------------=={ BD }==-------------------------------;;
;;                                                            ;;
;;  Label a LINE with its surveyor bearing                    ;;
;;  (N DD%%dMM'SS" E/W) and length. MText placed at midpoint, ;;
;;  rotated along the line and flipped if upside-down so it   ;;
;;  always reads left-to-right.                               ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.1  -  2026-05-20                              ;;
;;  Command:  BD                                              ;;
;;  Args:     pick a LINE                                     ;;
;;  Requires: _utils.lsp (c3d:txth, c3d:az->bearing)          ;;
;;  Example:  BD -> pick line -> "N 12%%d34'56" E\\P125.43'"  ;;
;;------------------------------------------------------------;;

(defun c:BD (/ ent edata p1 p2 math-ang az dist mid bear lbl rot txth)
  (setq txth (c3d:txth))
  (setq ent (car (entsel "\nPick a LINE: ")))
  (if ent
    (progn
      (setq edata (entget ent))
      (if (= (cdr (assoc 0 edata)) "LINE")
        (progn
          (setq p1 (cdr (assoc 10 edata))
                p2 (cdr (assoc 11 edata))
                math-ang (angle p1 p2)
                az   (- (/ pi 2) math-ang)
                dist (distance p1 p2)
                mid  (mapcar '(lambda (a b) (/ (+ a b) 2.0)) p1 p2)
                bear (c3d:az->bearing az)
                lbl  (strcat bear "\\P" (rtos dist 2 2) "'")
                rot  math-ang)
          (if (and (> rot (/ pi 2)) (< rot (* 3 (/ pi 2))))
            (setq rot (- rot pi)))
          (entmake
            (list
              '(0 . "MTEXT")
              '(100 . "AcDbEntity")
              '(100 . "AcDbMText")
              (cons 10 mid)
              (cons 40 txth)
              (cons 1  lbl)
              (cons 50 rot)
              '(71 . 8)))
          (princ (strcat "\n" bear "   " (rtos dist 2 2) "'")))
        (princ "\nPicked object is not a LINE."))))
  (princ))
