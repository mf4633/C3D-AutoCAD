;; BD - label a LINE with its surveyor bearing (N DD MM SS E/W) and length.
;; Label is MTEXT placed at midpoint, rotated to the line and flipped if
;; upside-down so it always reads left-to-right.
;; Command: BD

(defun rad->dms (rad / d m s deg)
  (setq deg (* (/ rad pi) 180.0)
        d   (fix deg)
        m   (* (- deg d) 60.0)
        s   (* (- m (fix m)) 60.0)
        m   (fix m)
        s   (atof (rtos s 2 0)))
  (if (>= s 60) (progn (setq s 0)   (setq m (1+ m))))
  (if (>= m 60) (progn (setq m 0)   (setq d (1+ d))))
  (strcat (itoa d) "%%d"
          (if (< m 10) "0" "") (itoa m) "'"
          (if (< s 10) "0" "") (itoa (fix s)) "\""))

(defun az->bearing (az / pi2 ns ew theta)
  (setq pi2 (* 2 pi)
        az  (rem az pi2))
  (if (< az 0) (setq az (+ az pi2)))
  (cond
    ((<= az (/ pi 2))           (setq ns "N" ew "E" theta az))
    ((<= az pi)                 (setq ns "S" ew "E" theta (- pi az)))
    ((<= az (* 3 (/ pi 2)))     (setq ns "S" ew "W" theta (- az pi)))
    (T                          (setq ns "N" ew "W" theta (- pi2 az))))
  (strcat ns " " (rad->dms theta) " " ew))

(defun c:BD (/ ent edata p1 p2 math-ang az dist mid bear lbl rot txth)
  (setq txth (getvar "TEXTSIZE"))
  (if (or (null txth) (<= txth 0)) (setq txth (getvar "DIMTXT")))
  (if (or (null txth) (<= txth 0)) (setq txth 1.0))
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
                bear (az->bearing az)
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
