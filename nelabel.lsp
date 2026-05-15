;; NE - place a N/E coordinate label at picked points (repeating).
;; Label is MTEXT formatted as:   N nnnn.nn
;;                                E eeee.ee
;; Command: NE

(defun c:NE (/ p lbl txth)
  (setq txth (getvar "TEXTSIZE"))
  (if (or (null txth) (<= txth 0)) (setq txth (getvar "DIMTXT")))
  (if (or (null txth) (<= txth 0)) (setq txth 1.0))
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
