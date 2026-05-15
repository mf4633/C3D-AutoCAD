;; PA - audit the drawing, then purge everything possible (run three times
;; to clear nested references). Safe to repeat.
;; Command: PA

(defun c:PA ()
  (command "_.AUDIT" "Y")
  (command "_.-PURGE" "_ALL" "*" "_N")
  (command "_.-PURGE" "_ALL" "*" "_N")
  (command "_.-PURGE" "_ALL" "*" "_N")
  (command "_.-PURGE" "_REG" "*" "_N")
  (princ "\nDrawing audited and purged.")
  (princ))
