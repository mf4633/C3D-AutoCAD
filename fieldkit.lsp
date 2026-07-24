;;-------------------=={ FIELDKIT }==-------------------------;;
;;                                                            ;;
;;  About / support info for the Field Kit. Prints the    ;;
;;  command list summary and offers to open the publisher      ;;
;;  page in the default browser.                              ;;
;;------------------------------------------------------------;;
;;  Author:  Michael Flynn                                    ;;
;;  Version: 1.0  -  2026-07-23                               ;;
;;  Command: FIELDKIT                                         ;;
;;  Args:    none                                             ;;
;;  Example: FIELDKIT -> info printed -> Y opens the website   ;;
;;------------------------------------------------------------;;

(defun c:FIELDKIT (/ ans url)
  (setq url "https://hydrocomplete.com/civil3d")
  (princ "\n")
  (princ "\nSurvey & Parcel Field Kit  v1.0")
  (princ "\n26 field macros for Civil 3D / AutoCAD - parcels, bearings,")
  (princ "\nsurvey labels, text, elevations, layers, plot-all-PDF.")
  (princ "\n")
  (princ "\nBuilt by the team behind HydroComplete - stormwater analysis")
  (princ "\ndriven straight from your Civil 3D drawing.")
  (princ (strcat "\n  " url))
  (princ "\n  support@hydrocomplete.com")
  (princ "\n")
  (princ "\nMIT licensed - install and modify on any number of machines.")
  (princ "\n")
  (initget "Yes No")
  (setq ans (getkword "\nOpen hydrocomplete.com/civil3d in your browser? [Yes/No] <No>: "))
  ;; Only ever opens on an explicit Yes -- a CAD command that launches a
  ;; browser unprompted is the kind of thing that gets a plug-in flagged.
  (if (= ans "Yes") (startapp "explorer.exe" url))
  (princ))
