;;-------------------=={ BC }==-------------------------------;;
;;                                                            ;;
;;  Count blocks in the selection (or whole drawing) grouped  ;;
;;  by block name. Output at the command line, sorted by      ;;
;;  block name with a total.                                  ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: BC                                               ;;
;;  Args:    selection of INSERTs, or Enter for ALL           ;;
;;  Example: BC -> Enter -> "TREE: 12, INLET: 4, TOTAL: 16"   ;;
;;------------------------------------------------------------;;

(defun c:BC (/ ss alist n ent name pair sorted total)
  (princ "\nSelect blocks (Enter for ALL): ")
  (setq ss (ssget '((0 . "INSERT"))))
  (if (null ss) (setq ss (ssget "X" '((0 . "INSERT")))))
  (if ss
    (progn
      (setq alist '() n 0 total 0)
      (repeat (sslength ss)
        (setq ent  (ssname ss n)
              name (cdr (assoc 2 (entget ent))))
        (if (setq pair (assoc name alist))
          (setq alist (subst (cons name (1+ (cdr pair))) pair alist))
          (setq alist (cons (cons name 1) alist)))
        (setq total (1+ total))
        (setq n (1+ n)))
      (setq sorted (vl-sort alist
                            (function (lambda (a b) (< (car a) (car b))))))
      (princ "\n--- Block Counts ---")
      (foreach p sorted
        (princ (strcat "\n  " (car p) " : " (itoa (cdr p)))))
      (princ (strcat "\n--- Total: " (itoa total) " ---"))))
  (princ))
