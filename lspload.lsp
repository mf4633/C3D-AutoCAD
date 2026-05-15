;; LSPLOAD - pick any .lsp in a folder; every .lsp in that folder is loaded.
;; Handy for loading this whole repo in one step.
;; Command: LSPLOAD

(defun c:LSPLOAD (/ pick dir files f)
  (setq pick (getfiled "Select any .lsp in the folder to load all" "" "lsp" 0))
  (if pick
    (progn
      (setq dir   (vl-filename-directory pick)
            files (vl-directory-files dir "*.lsp" 1))
      (foreach f files
        (load (strcat dir "\\" f))
        (princ (strcat "\nLoaded: " f)))
      (princ (strcat "\nLoaded " (itoa (length files)) " file(s) from " dir))))
  (princ))
