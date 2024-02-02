(defun c:MAKEUPPER ()
  (vl-load-com) ; Load Visual LISP extensions
  ;; Get a selection set of all MText and DText entities
  (setq ss (ssget "X" '((0 . "MTEXT,DTEXT"))))
  (setq sslen (sslength ss))
  (setq i 0)
  ;; Iterate through each entity in the selection set
  (while (< i sslen)
    (setq ent (ssname ss i)) ; Get the entity name
    (setq entobj (vlax-ename->vla-object ent)) ; Convert entity name to a VLA object for manipulation
    ;; Explicitly convert text to uppercase
    (vla-put-textstring entobj (strcase (vla-get-textstring entobj) F)) ; Ensure T for lower, F for upper
    (setq i (1+ i))
  )
  (princ "\nAll text objects have been converted to uppercase.")
  (princ)
)
