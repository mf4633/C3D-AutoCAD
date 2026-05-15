;; FLAT - flatten selected objects to Z=0 in place.
;; Handles LINE, ARC, CIRCLE, TEXT, MTEXT, INSERT (any 3D-point DXF group)
;; plus LWPOLYLINE elevation (DXF 38).
;; For 3DPOLY/3DFACE/MESH/SURFACE, explode first.
;; Command: FLAT

(defun c:FLAT (/ ss n ent dxflist newlist)
  (princ "\nSelect objects to flatten to Z=0 (Enter for ALL): ")
  (if (null (setq ss (ssget))) (setq ss (ssget "X")))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              dxflist (entget ent))
        (setq newlist
              (mapcar
                (function
                  (lambda (pr / k v)
                    (setq k (car pr) v (cdr pr))
                    (cond
                      ((and (member k '(10 11 12 13))
                            (listp v) (= (length v) 3))
                       (cons k (list (car v) (cadr v) 0.0)))
                      ((= k 38) (cons 38 0.0))
                      ((= k 39) (cons 39 0.0))
                      (T pr))))
                dxflist))
        (entmod newlist)
        (setq n (1+ n)))
      (princ (strcat "\nFlattened " (itoa (sslength ss)) " object(s) to Z=0."))))
  (princ))
