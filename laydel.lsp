;;-------------------=={ LDEL }==-----------------------------;;
;;                                                            ;;
;;  Delete every object on the layer of the picked entity.    ;;
;;  Confirmation prompt is required (defaults to NO).         ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.2  -  2026-07-07                               ;;
;;  Command: LDEL                                             ;;
;;  Args:    pick one object on the target layer              ;;
;;  Example: LDEL -> pick tree -> Y -> all trees gone         ;;
;;------------------------------------------------------------;;

;; Is layer LNAME locked? Returns T if so (ERASE silently ignores locked
;; layers, so LDEL must check before reporting success).
(defun ldel:locked-p (lname / doc lay locked)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (if (not (vl-catch-all-error-p
             (setq lay (vl-catch-all-apply
                         '(lambda ()
                            (vla-Item (vla-get-Layers doc) lname))))))
    (setq locked (= (vla-get-Lock lay) :vlax-true)))
  locked)

(defun c:LDEL (/ ent layname ss yn)
  (vl-load-com)
  (setq ent (car (entsel "\nPick object on the layer to wipe: ")))
  (if ent
    (progn
      (setq layname (cdr (assoc 8 (entget ent))))
      (setq yn (strcase
                 (getstring (strcat "\nDelete ALL objects on layer \""
                                    layname "\"? [Y/N] <N>: "))))
      (cond
        ((/= yn "Y")
         (princ "\nCancelled."))
        ((ldel:locked-p layname)
         (princ (strcat "\nLayer \"" layname
                        "\" is LOCKED; unlock it first. Nothing deleted.")))
        ((setq ss (ssget "X" (list (cons 8 layname))))
         (command "_.ERASE" ss "")
         (princ (strcat "\nDeleted " (itoa (sslength ss))
                        " object(s) from layer " layname)))
        (T
         (princ "\nNo objects found on that layer.")))))
  (princ))
