;;-------------------=={ _utils }==---------------------------;;
;;                                                            ;;
;;  Shared helpers used across this library. Load this file   ;;
;;  before any routine that calls c3d:* functions. LSPLOAD    ;;
;;  and acaddoc.lsp load it first by filename.                ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-07-07                               ;;
;;------------------------------------------------------------;;
;;  Exports:                                                  ;;
;;    (c3d:txth)              -> current text height          ;;
;;    (c3d:bbcenter obj)      -> bounding-box center 3D pt    ;;
;;    (c3d:rad->dms rad)      -> "DD%%dMM'SS\""               ;;
;;    (c3d:az->bearing az)    -> "N DD%%dMM'SS\" E"           ;;
;;    (c3d:mtext-case s mode) -> case-fold MTEXT, keep codes  ;;
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

;; Case-transform the *visible* text of an MTEXT string while leaving inline
;; formatting untouched: backslash codes (\P \L \l \O \o \K \k, escaped \\ \{
;; \} \~, and parametric \A \C \c \F \f \H \Q \T \W \p \S ... ; runs) and the
;; grouping braces { }. MODE is 'upper, 'lower, or 'title. Plain TEXT / ATTDEF
;; carry no such codes -- use (strcase ...) on those, not this (a literal
;; backslash in a path like "C:\Temp" would otherwise look like a code).
(defun c3d:mtext-case (s mode / params seps lst out cap ch nx done c2)
  (setq params '(65 67 99 70 102 72 81 84 87 112 83) ; A C c F f H Q T W p S
        seps   '(32 9 10 13 46 45 95 47)             ; space tab lf cr . - _ /
        lst    (vl-string->list s)
        out    '()
        cap    T)
  (while lst
    (setq ch (car lst))
    (cond
      ;; backslash-introduced formatting code
      ((= ch 92)
       (setq nx (cadr lst))
       (cond
         ((null nx)                                  ; trailing backslash
          (setq out (cons ch out) lst (cdr lst)))
         ((member nx params)                         ; parametric: copy to ';'
          (setq out (cons ch out) lst (cdr lst) done nil)
          (while (and lst (not done))
            (setq c2 (car lst) out (cons c2 out) lst (cdr lst))
            (if (= c2 59) (setq done T))))
         ((member nx '(80 76 108 79 111 75 107 92 123 125 126)) ; toggles / \\ \{ \} \~
          (setq out (cons nx (cons ch out)) lst (cddr lst))
          (if (and (eq mode 'title) (= nx 80)) (setq cap T)))   ; \P starts a new line
         (T                                          ; unknown: keep '\', fold rest
          (setq out (cons ch out) lst (cdr lst)))))
      ;; unescaped grouping braces: keep, don't fold, preserve title state
      ((or (= ch 123) (= ch 125))
       (setq out (cons ch out) lst (cdr lst)))
      ;; visible character
      (T
       (cond
         ((eq mode 'upper)
          (setq out (cons (if (and (>= ch 97) (<= ch 122)) (- ch 32) ch) out)))
         ((eq mode 'lower)
          (setq out (cons (if (and (>= ch 65) (<= ch 90)) (+ ch 32) ch) out)))
         ((member ch seps)
          (setq out (cons ch out) cap T))
         (cap
          (setq out (cons (if (and (>= ch 97) (<= ch 122)) (- ch 32) ch) out)
                cap nil))
         (T
          (setq out (cons (if (and (>= ch 65) (<= ch 90)) (+ ch 32) ch) out))))
       (setq lst (cdr lst)))))
  (vl-list->string (reverse out)))

(princ "\n_utils loaded.")
(princ)
