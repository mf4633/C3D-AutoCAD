;;-------------------=={ T2M }==------------------------------;;
;;                                                            ;;
;;  Convert DTEXT / TEXT entities into MTEXT, preserving      ;;
;;  height, style, rotation, and insertion point. Original    ;;
;;  TEXT is deleted.                                          ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: T2M                                              ;;
;;  Args:    selection of TEXT                                ;;
;;  Example: T2M -> select notes -> notes become MTEXT        ;;
;;------------------------------------------------------------;;

(defun c:T2M (/ ss n ent obj txt ins ht st rot)
  (vl-load-com)
  (princ "\nSelect TEXT to convert to MTEXT: ")
  (setq ss (ssget '((0 . "TEXT"))))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              obj (vlax-ename->vla-object ent)
              txt (vla-get-TextString obj)
              ins (vlax-get obj 'InsertionPoint)
              ht  (vla-get-Height obj)
              st  (vla-get-StyleName obj)
              rot (vla-get-Rotation obj))
        (entmake
          (list
            '(0 . "MTEXT")
            '(100 . "AcDbEntity")
            '(100 . "AcDbMText")
            (cons 10 ins)
            (cons 40 ht)
            (cons 1 txt)
            (cons 7 st)
            (cons 50 rot)
            '(71 . 7)))
        (entdel ent)
        (setq n (1+ n)))
      (princ (strcat "\nConverted " (itoa (sslength ss)) " TEXT -> MTEXT."))))
  (princ))
