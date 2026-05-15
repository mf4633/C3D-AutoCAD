;; LUI - turn ON and THAW every layer in the drawing. Reverse of LI.
;; Command: LUI

(defun c:LUI ()
  (vl-load-com)
  (vlax-for lay
    (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object)))
    (vl-catch-all-apply '(lambda () (vla-put-LayerOn lay :vlax-true)))
    (vl-catch-all-apply '(lambda () (vla-put-Freeze  lay :vlax-false))))
  (princ "\nAll layers ON and thawed.")
  (princ))
