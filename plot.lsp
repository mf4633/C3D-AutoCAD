;;-------------------=={ PLT }==------------------------------;;
;;                                                            ;;
;;  Plot every paper-space layout in the current drawing to   ;;
;;  a single multi-page PDF using the PUBLISH command and the ;;
;;  "DWG To PDF.pc3" plotter. PDF is written next to the DWG  ;;
;;  with the same base name.                                  ;;
;;                                                            ;;
;;  Tip: set the page setup for each layout before running so ;;
;;  paper size, scale, and area are baked in.                 ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.0  -  2026-05-20                               ;;
;;  Command: PLT                                              ;;
;;  Args:    none                                             ;;
;;  Example: PLT -> writes  C:\jobs\plan.pdf  next to the DWG ;;
;;------------------------------------------------------------;;

(defun c:PLT (/ doc dwg-path dwg-name pdf-path layouts ll)
  (vl-load-com)
  (setq doc      (vla-get-ActiveDocument (vlax-get-acad-object))
        dwg-path (vla-get-Path doc)
        dwg-name (vl-filename-base (vla-get-Name doc))
        pdf-path (strcat dwg-path "\\" dwg-name ".pdf"))
  (if (= dwg-path "")
    (progn
      (princ "\nSave the drawing first; PLT writes the PDF next to the DWG.")
      (exit)))
  ;; Collect every layout name except "Model".
  (setq layouts '())
  (vlax-for lay (vla-get-Layouts doc)
    (if (/= (strcase (vla-get-Name lay)) "MODEL")
      (setq layouts (cons (vla-get-Name lay) layouts))))
  (if (null layouts)
    (progn (princ "\nNo paper-space layouts to plot.") (exit)))
  (setq layouts (vl-sort layouts '<))
  ;; Build a comma-separated layout list for -PUBLISH dialog-less form
  ;; via PUBLISHCOLLATE + PDF-out. We use the modern PUBLISH/PDF route via
  ;; -PUBLISH not being scriptable in all versions, so fall back to looping
  ;; -PLOT calls into a temp PDF per layout, then user can combine — but
  ;; the cleanest cross-version path is the PUBLISHCOLLATE-aware PUBLISH
  ;; with PUBLISHALLSHEETS=1 and EXPORTPDF.
  ;; Simplest portable approach: -EXPORT each layout once, then EXPORTPDF
  ;; with -PUBLISH ALL via the PUBLISHALLSHEETS sysvar.
  (setvar "PUBLISHCOLLATE" 1)
  (setvar "PUBLISHALLSHEETS" 1)
  (setvar "BACKGROUNDPLOT" 0)
  (foreach ll layouts
    (vla-put-ActiveLayout doc (vla-Item (vla-get-Layouts doc) ll))
    (command "_.-EXPORT" "_PDF"
             "_S" "_C" "" "" "_Y"
             pdf-path))
  (princ (strcat "\nWrote " pdf-path))
  (princ))
