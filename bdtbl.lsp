;;-------------------=={ BDTBL }==----------------------------;;
;;                                                            ;;
;;  Build a Bearings-and-Distances table from a closed (or    ;;
;;  open) polyline. For each segment, walk vertex to vertex   ;;
;;  and report L#, bearing (N DD%%dMM'SS" E/W), length in     ;;
;;  feet. Output is a true AutoCAD TABLE entity, anchored at  ;;
;;  a picked insertion point.                                 ;;
;;                                                            ;;
;;  Arc segments are labelled with their chord bearing and    ;;
;;  arc length; consider exploding to lines first for survey  ;;
;;  metes-and-bounds work.                                    ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.1  -  2026-07-07                              ;;
;;  Command:  BDTBL                                           ;;
;;  Args:     pick a polyline, then an insertion point        ;;
;;  Requires: _utils.lsp (c3d:az->bearing)                    ;;
;;  Example:  BDTBL -> pick boundary -> pick blank space      ;;
;;            -> 3-column table inserted                      ;;
;;------------------------------------------------------------;;

(defun c:BDTBL (/ ent ins)
  (vl-load-com)
  (setq ent (car (entsel "\nPick polyline for bearings table: ")))
  (cond
    ((null ent)
     (princ "\nNothing picked."))
    ((not (member (cdr (assoc 0 (entget ent))) '("LWPOLYLINE" "POLYLINE")))
     (princ "\nNot a polyline."))
    ((null (setq ins (getpoint "\nInsertion point for table: ")))
     (princ "\nNo insertion point."))
    (T
     (bdtbl:build ent ins)))
  (princ))

;; Build the bearings-and-distances table for polyline ENT at point INS.
(defun bdtbl:build (ent ins / obj doc space tbl rows nv i p1 p2 az dist bear th)
  (setq obj   (vlax-ename->vla-object ent)
        nv    (fix (1+ (vlax-curve-getEndParam obj)))
        rows  '()
        i     0
        th    (* 1.5 (c3d:txth)))
  (repeat (1- nv)
    (setq p1   (vlax-curve-getPointAtParam obj i)
          p2   (vlax-curve-getPointAtParam obj (1+ i))
          dist (vlax-curve-getDistAtParam obj (1+ i))
          dist (- dist (vlax-curve-getDistAtParam obj i))
          az   (- (/ pi 2) (angle p1 p2))
          bear (c3d:az->bearing az)
          rows (cons (list (strcat "L" (itoa (1+ i)))
                           bear
                           (strcat (rtos dist 2 2) "'"))
                     rows))
    (setq i (1+ i)))
  (setq rows (reverse rows))
  ;; Build the table.
  (setq doc   (vla-get-ActiveDocument (vlax-get-acad-object))
        space (if (= 1 (getvar "CVPORT"))
                (vla-get-PaperSpace doc)
                (vla-get-ModelSpace doc))
        tbl   (vla-AddTable space
                            (vlax-3d-point ins)
                            (+ 2 (length rows)) ; rows: title + header + data
                            3                   ; columns
                            (* th 1.5)
                            (* th 8.0)))
  (vla-SetText tbl 0 0 "BEARINGS AND DISTANCES")
  (vla-SetText tbl 1 0 "LINE")
  (vla-SetText tbl 1 1 "BEARING")
  (vla-SetText tbl 1 2 "DISTANCE")
  (setq i 2)
  (foreach r rows
    (vla-SetText tbl i 0 (nth 0 r))
    (vla-SetText tbl i 1 (nth 1 r))
    (vla-SetText tbl i 2 (nth 2 r))
    (setq i (1+ i)))
  (princ (strcat "\nInserted bearings table: " (itoa (length rows)) " segment(s)."))
  (princ))
