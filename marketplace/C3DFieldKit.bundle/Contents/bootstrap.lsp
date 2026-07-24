;;-------------------=={ bootstrap }==------------------------;;
;;  Field Kit — Autodesk autoloader bootstrap.              ;;
;;  Loaded at AutoCAD startup (LoadOnAutoCADStartup).         ;;
;;  Ensures _utils.lsp is available before any command runs.  ;;
;;------------------------------------------------------------;;

(defun c3dfieldkit:load-utils (/ here utils)
  (setq here  (vl-filename-directory (findfile "bootstrap.lsp"))
        utils (if here (strcat here "\\_utils.lsp") nil))
  (if (and utils (findfile utils))
    (progn
      (load utils)
      ;; Single-line load banner. Keep it to ONE line -- plugins that chatter on
      ;; every drawing open get flagged in review and annoy users.
      (princ "\nField Kit loaded — by HydroComplete (hydrocomplete.com/civil3d)"))
    (princ "\nField Kit: _utils.lsp not found.")))
(c3dfieldkit:load-utils)
(princ)