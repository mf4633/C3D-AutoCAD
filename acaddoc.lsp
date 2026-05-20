;;-------------------=={ acaddoc }==--------------------------;;
;;                                                            ;;
;;  Auto-load every .lsp in this folder when any drawing      ;;
;;  opens. Drop this folder into the AutoCAD Support File     ;;
;;  Search Path (Options > Files > Support File Search Path)  ;;
;;  and AutoCAD will pick up this acaddoc.lsp at startup,     ;;
;;  which then loads every sibling .lsp.                      ;;
;;                                                            ;;
;;  _utils.lsp is loaded first so other routines can call     ;;
;;  c3d:* helpers safely.                                     ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.0  -  2026-05-20                               ;;
;;------------------------------------------------------------;;

(
 (lambda (/ here files first rest f)
   (setq here  (vl-filename-directory (findfile "acaddoc.lsp"))
         files (vl-directory-files here "*.lsp" 1))
   ;; Skip self.
   (setq files (vl-remove-if
                 '(lambda (n) (member (strcase n) '("ACADDOC.LSP")))
                 files))
   ;; Load _utils.lsp first if present.
   (setq first (vl-remove-if-not
                 '(lambda (n) (= (strcase n) "_UTILS.LSP")) files))
   (setq rest  (vl-remove-if
                 '(lambda (n) (= (strcase n) "_UTILS.LSP")) files))
   (foreach f (append first rest)
     (vl-catch-all-apply 'load (list (strcat here "\\" f))))
   (princ (strcat "\nC3D-AutoCAD: loaded "
                  (itoa (length (append first rest)))
                  " routine(s) from " here)))
)

(princ)
