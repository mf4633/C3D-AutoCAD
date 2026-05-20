;;-------------------=={ _utils }==---------------------------;;
;;                                                            ;;
;;  Shared helpers used across this library. Load this file   ;;
;;  before any routine that calls c3d:* functions. LSPLOAD    ;;
;;  and acaddoc.lsp load it first by filename.                ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.0  -  2026-05-20                               ;;
;;------------------------------------------------------------;;
;;  Exports:                                                  ;;
;;    (c3d:txth)              -> current text height          ;;
;;    (c3d:bbcenter obj)      -> bounding-box center 3D pt    ;;
;;    (c3d:rad->dms rad)      -> "DD%%dMM'SS\""               ;;
;;    (c3d:az->bearing az)    -> "N DD%%dMM'SS\" E"           ;;
;;------------------------------------------------------------;;

(vl-load-com)

;; Current label height: TEXTSIZE, falling back to DIMTXT, then 1.0.
(defun c3d:txth (/ h)
  (setq h (getvar "TEXTSIZE"))
  (if (or (null h) (<= h 0)) (setq h (getvar "DIMTXT")))
  (if (or (null h) (<= h 0)) (setq h 1.0))
  h)

;; Bounding-box center of a VLA object (works for hatch, region, closed
;; polyline, circle, ellipse, etc.).
(defun c3d:bbcenter (obj / minp maxp)
  (vla-GetBoundingBox obj 'minp 'maxp)
  (mapcar '(lambda (a b) (/ (+ a b) 2.0))
          (vlax-safearray->list minp)
          (vlax-safearray->list maxp)))

;; Radians to degrees-minutes-seconds string using AutoCAD's %%d code.
(defun c3d:rad->dms (rad / d m s deg)
  (setq deg (* (/ rad pi) 180.0)
        d   (fix deg)
        m   (* (- deg d) 60.0)
        s   (* (- m (fix m)) 60.0)
        m   (fix m)
        s   (atof (rtos s 2 0)))
  (if (>= s 60) (progn (setq s 0) (setq m (1+ m))))
  (if (>= m 60) (progn (setq m 0) (setq d (1+ d))))
  (strcat (itoa d) "%%d"
          (if (< m 10) "0" "") (itoa m) "'"
          (if (< s 10) "0" "") (itoa (fix s)) "\""))

;; Azimuth (radians, 0 = north, clockwise) to surveyor bearing string.
(defun c3d:az->bearing (az / pi2 ns ew theta)
  (setq pi2 (* 2 pi)
        az  (rem az pi2))
  (if (< az 0) (setq az (+ az pi2)))
  (cond
    ((<= az (/ pi 2))       (setq ns "N" ew "E" theta az))
    ((<= az pi)             (setq ns "S" ew "E" theta (- pi az)))
    ((<= az (* 3 (/ pi 2))) (setq ns "S" ew "W" theta (- az pi)))
    (T                      (setq ns "N" ew "W" theta (- pi2 az))))
  (strcat ns " " (c3d:rad->dms theta) " " ew))

(princ "\n_utils loaded.")
(princ)
