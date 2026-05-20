;;-------------------=={ PA }==-------------------------------;;
;;                                                            ;;
;;  Audit the drawing, then purge everything possible. Three  ;;
;;  PURGE passes clear nested references; an extra _REG pass  ;;
;;  drops orphaned registered-application entries. Safe to    ;;
;;  repeat.                                                   ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: PA                                               ;;
;;  Args:    none                                             ;;
;;  Example: PA -> drawing shrinks; layers/styles cleaned out ;;
;;------------------------------------------------------------;;

(defun c:PA ()
  (command "_.AUDIT" "Y")
  (command "_.-PURGE" "_ALL" "*" "_N")
  (command "_.-PURGE" "_ALL" "*" "_N")
  (command "_.-PURGE" "_ALL" "*" "_N")
  (command "_.-PURGE" "_REG" "*" "_N")
  (princ "\nDrawing audited and purged.")
  (princ))
