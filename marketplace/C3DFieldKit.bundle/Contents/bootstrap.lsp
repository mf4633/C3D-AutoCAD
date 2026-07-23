;;-------------------=={ bootstrap }==------------------------;;
;;  C3D Field Kit — Autodesk autoloader bootstrap.              ;;
;;  Loaded at AutoCAD startup (LoadOnAutoCADStartup).         ;;
;;  Ensures _utils.lsp is available before any command runs.  ;;
;;------------------------------------------------------------;;

(defun c3dfieldkit:load-utils (/ here utils)
  (setq here  (vl-filename-directory (findfile "bootstrap.lsp"))
        utils (if here (strcat here "\\_utils.lsp") nil))
  (if (and utils (findfile utils))
    (progn
      (load utils)
      (princ "\nC3D Field Kit: helpers loaded."))
    (princ "\nC3D Field Kit: _utils.lsp not found.")))
(c3dfieldkit:load-utils)
(princ)