;;-------------------=={ LI }==-------------------------------;;
;;                                                            ;;
;;  Isolate the layer of a picked object by turning every     ;;
;;  other layer off. Use LUI to restore.                      ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: LI                                               ;;
;;  Args:    pick one object on the layer to isolate          ;;
;;  Example: LI -> pick contour -> only contour layer visible ;;
;;------------------------------------------------------------;;

(defun c:LI (/ ent keep)
  (vl-load-com)
  (setq ent (car (entsel "\nPick object on layer to isolate: ")))
  (if ent
    (progn
      (setq keep (cdr (assoc 8 (entget ent))))
      (vlax-for lay
        (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object)))
        (if (/= (vla-get-Name lay) keep)
          (vl-catch-all-apply
            '(lambda () (vla-put-LayerOn lay :vlax-false)))))
      (princ (strcat "\nIsolated layer: " keep))))
  (princ))
