;;-------------------=={ LDEL }==-----------------------------;;
;;                                                            ;;
;;  Delete every object on the layer of the picked entity.    ;;
;;  Confirmation prompt is required (defaults to NO).         ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: LDEL                                             ;;
;;  Args:    pick one object on the target layer              ;;
;;  Example: LDEL -> pick tree -> Y -> all trees gone         ;;
;;------------------------------------------------------------;;

(defun c:LDEL (/ ent layname ss yn)
  (setq ent (car (entsel "\nPick object on the layer to wipe: ")))
  (if ent
    (progn
      (setq layname (cdr (assoc 8 (entget ent))))
      (setq yn (strcase
                 (getstring (strcat "\nDelete ALL objects on layer \""
                                    layname "\"? [Y/N] <N>: "))))
      (if (= yn "Y")
        (progn
          (setq ss (ssget "X" (list (cons 8 layname))))
          (if ss
            (progn
              (command "_.ERASE" ss "")
              (princ (strcat "\nDeleted " (itoa (sslength ss))
                             " object(s) from layer " layname)))
            (princ "\nNo objects found on that layer.")))
        (princ "\nCancelled."))))
  (princ))
