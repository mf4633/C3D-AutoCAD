;; ZO - zoom to selected objects (same effect as ZOOM > OBJECT but one step).
;; Command: ZO

(defun c:ZO (/ ss)
  (princ "\nSelect object(s) to zoom to: ")
  (setq ss (ssget))
  (if ss (command "_.ZOOM" "_OBJECT" ss ""))
  (princ))
