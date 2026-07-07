;;-------------------=={ TITLECASE }==------------------------;;
;;                                                            ;;
;;  Convert selected TEXT / MTEXT To Title Case. Capitalize   ;;
;;  the first letter of each word; spaces, tabs, hyphens,     ;;
;;  underscores, periods, and forward slashes are treated as  ;;
;;  word separators.                                          ;;
;;------------------------------------------------------------;;
;;  Author:   Michael Flynn                                   ;;
;;  Version:  1.2  -  2026-07-07                              ;;
;;  Command:  TITLECASE                                       ;;
;;  Args:     selection of TEXT/MTEXT                         ;;
;;  Requires: _utils.lsp (c3d:mtext-case, for MTEXT)          ;;
;;  Example:  TITLECASE -> select sheet title -> Title Case   ;;
;;------------------------------------------------------------;;

(defun tc-string (s / lst out cap c)
  (setq lst (vl-string->list s) out '() cap T)
  (foreach c lst
    (cond
      ((or (= c 32) (= c 9) (= c 10) (= c 13)
           (= c 46) (= c 45) (= c 95) (= c 47))
       (setq out (cons c out) cap T))
      (cap
       (setq out (cons (if (and (>= c 97) (<= c 122)) (- c 32) c) out)
             cap nil))
      (T
       (setq out (cons (if (and (>= c 65) (<= c 90)) (+ c 32) c) out)))))
  (vl-list->string (reverse out)))

(defun c:TITLECASE (/ ss n ent obj)
  (vl-load-com)
  (princ "\nSelect TEXT/MTEXT to title-case: ")
  (setq ss (ssget '((0 . "TEXT,MTEXT"))))
  (if ss
    (progn
      (setq n 0)
      (repeat (sslength ss)
        (setq ent (ssname ss n)
              obj (vlax-ename->vla-object ent))
        ;; MTEXT carries inline format codes; c3d:mtext-case skips them.
        ;; Plain TEXT has none, so tc-string (which treats every char as
        ;; visible, incl. backslashes) is the right tool there.
        (if (= (vla-get-ObjectName obj) "AcDbMText")
          (vla-put-TextString obj (c3d:mtext-case (vla-get-TextString obj) 'title))
          (vla-put-TextString obj (tc-string (vla-get-TextString obj))))
        (setq n (1+ n)))
      (princ (strcat "\nTitle-cased " (itoa (sslength ss)) " text object(s)."))))
  (princ))
