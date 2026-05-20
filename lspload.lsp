;;-------------------=={ LSPLOAD }==--------------------------;;
;;                                                            ;;
;;  Pick any .lsp in a folder; every .lsp in that folder is   ;;
;;  loaded. Handy for loading this whole repo in one step.    ;;
;;  Loads _utils.lsp first if present.                        ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-05-20                               ;;
;;  Command: LSPLOAD                                          ;;
;;  Args:    pick any .lsp in the target folder               ;;
;;  Example: LSPLOAD -> select bd.lsp -> loads all routines   ;;
;;------------------------------------------------------------;;

(defun c:LSPLOAD (/ pick dir files first rest f)
  (setq pick (getfiled "Select any .lsp in the folder to load all" "" "lsp" 0))
  (if pick
    (progn
      (setq dir   (vl-filename-directory pick)
            files (vl-directory-files dir "*.lsp" 1)
            first (vl-remove-if-not
                    '(lambda (n) (= (strcase n) "_UTILS.LSP")) files)
            rest  (vl-remove-if
                    '(lambda (n) (= (strcase n) "_UTILS.LSP")) files))
      (foreach f (append first rest)
        (load (strcat dir "\\" f))
        (princ (strcat "\nLoaded: " f)))
      (princ (strcat "\nLoaded " (itoa (length files)) " file(s) from " dir))))
  (princ))
