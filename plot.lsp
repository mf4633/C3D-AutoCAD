;;-------------------=={ PLT }==------------------------------;;
;;                                                            ;;
;;  Plot every paper-space layout in the current drawing to   ;;
;;  a single multi-page PDF. Writes a DSD (Drawing Set        ;;
;;  Description) and runs -PUBLISH headlessly, which collates ;;
;;  every layout into one PDF next to the DWG with the same   ;;
;;  base name.                                                ;;
;;                                                            ;;
;;  Each layout is published through its OWN page setup, so   ;;
;;  set page size / scale / plot area (and a PDF plotter such ;;
;;  as "DWG To PDF.pc3") on each layout before running.       ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.1  -  2026-07-07                               ;;
;;  Command: PLT                                              ;;
;;  Args:    none                                             ;;
;;  Example: PLT -> writes  C:\jobs\plan.pdf  next to the DWG ;;
;;------------------------------------------------------------;;

(defun c:PLT (/ doc dwg-dir dwg dwg-base pdf-path dsd layouts f pub)
  (vl-load-com)
  (setq doc      (vla-get-ActiveDocument (vlax-get-acad-object))
        dwg-dir  (vla-get-Path doc)
        dwg      (vla-get-FullName doc)
        dwg-base (vl-filename-base dwg))
  (cond
    ;; Unsaved drawing: no folder to write the PDF next to.
    ((= dwg-dir "")
     (princ "\nSave the drawing first; PLT writes the PDF next to the DWG."))
    (T
     (setq pdf-path (strcat dwg-dir "\\" dwg-base ".pdf")
           layouts  '())
     ;; Collect every layout name except "Model", sorted by name.
     (vlax-for lay (vla-get-Layouts doc)
       (if (/= (strcase (vla-get-Name lay)) "MODEL")
         (setq layouts (cons (vla-get-Name lay) layouts))))
     (cond
       ((null layouts)
        (princ "\nNo paper-space layouts to plot."))
       (T
        (setq layouts (vl-sort layouts '<)
              dsd      (vl-filename-mktemp "c3dplt" nil ".dsd"))
        ;; --- Write the DSD that -PUBLISH consumes without a dialog. ---
        (setq f (open dsd "w"))
        (write-line "[DWF6Version]" f)
        (write-line "Ver=1" f)
        (foreach ll layouts
          (write-line (strcat "[DWF6Sheet:" dwg-base "-" ll "]") f)
          (write-line "Has3DDWF=0" f)
          (write-line "Setup=" f)                       ; blank = layout's own page setup
          (write-line (strcat "OriginalSheetPath=" dwg) f)
          (write-line (strcat "Dwg=" dwg) f)
          (write-line (strcat "Layout=" ll) f))
        (write-line "[Target]" f)
        (write-line "Type=6" f)                         ; 6 = single PDF file for the whole set
        (write-line (strcat "DWG=" pdf-path) f)
        (write-line (strcat "OUT=" dwg-dir) f)
        (write-line "PWD=" f)
        (close f)
        ;; PUBLISHCOLLATE=1 -> one multi-page file; BACKGROUNDPLOT=0 -> finish
        ;; before we report the path.
        (setvar "PUBLISHCOLLATE" 1)
        (setvar "BACKGROUNDPLOT" 0)
        (setq pub (vl-catch-all-apply
                    '(lambda () (command "_.-PUBLISH" dsd))))
        (vl-file-delete dsd)
        (if (vl-catch-all-error-p pub)
          (princ (strcat "\nPUBLISH failed: "
                         (vl-catch-all-error-message pub)))
          (princ (strcat "\nWrote " pdf-path
                         "  (" (itoa (length layouts)) " layout(s)).")))))))
  (princ))
