;;-------------------=={ ZO }==-------------------------------;;
;;                                                            ;;
;;  Zoom to selected objects (same effect as ZOOM > OBJECT    ;;
;;  but a single command).                                    ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: ZO                                               ;;
;;  Args:    selection of objects                             ;;
;;  Example: ZO -> pick block -> view fills with the block    ;;
;;------------------------------------------------------------;;

(defun c:ZO (/ ss)
  (princ "\nSelect object(s) to zoom to: ")
  (setq ss (ssget))
  (if ss (command "_.ZOOM" "_OBJECT" ss ""))
  (princ))
