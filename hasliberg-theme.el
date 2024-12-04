;;; hasliberg-theme.el --- Serene theme inspired by Swiss alps. -*- lexical-binding:t -*-

;; Copyright (C) 2024  Free Software Foundation, Inc.

;; Author: Ryota Sawada <rytswd@gmail.com>
;; Maintainer: Ryota Sawada <rytswd@gmail.com>
;; URL: https://github.com/rytswd/hasliberg-theme
;; Keywords: theme
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; The theme is only meant to provide my own prefered colour setup.

;;; Acknowledgments:

;; A lot of configurations were inspired by ef-themes by Prot.

;;; Code:

;;;###theme-autoload
(deftheme hasliberg
  "Theme inspired by Swiss alps"
  :background-mode 'dark
  :kind 'color-scheme)

;;;;----------------------------------------
;;;   Configuration
;;------------------------------------------
(defgroup hasliberg-theme nil
  "Options for hasliberg-theme."
  :group 'hasliberg-theme
  :prefix "hasliberg-theme-")
(defconst hasliberg-theme-lch-type
  '(plist :options ((:luminance float)
                    (:chroma float)
                    (:hue float)))
  "A plist defining LuvLCh input.")
(defun hasliberg-theme--validate-and-set-lch (symbol value)
  "Set SYMBOL to VALUE if it is a valid LCH colour.
VALUE must be a plist containing :luminance, :chroma, and :hue with float values.
Luminance should be between 0 and 100, chroma should be non-negative, and hue should be between 0 and 360."
  ;; This assumes the use of `hasliberg-theme-lch-type'.
  (let ((luminance (plist-get value :luminance))
        (chroma (plist-get value :chroma))
        (hue (plist-get value :hue))
        (errors '()))
    (unless (and luminance chroma hue)
      (push "LCH value must include :luminance, :chroma, and :hue" errors))
    (unless (and (floatp luminance) (floatp chroma) (floatp hue))
      (push (format "LCH components must be float values: %S" value) errors))
    (when (and luminance (or (< luminance 0) (> luminance 100)))
      (push (format "Luminance value %f must be between 0 and 100" luminance) errors))
    ;; NOTE: I need to double check on the valid chroma value.
    ;; I took this value from https://facelessuser.github.io/coloraide/colors/lchuv/
    (when (and chroma (or (< chroma 0) (> chroma 220)))
      (push (format "Chroma value %f must be non-negative" chroma) errors))
    (when (and hue (or (< hue 0) (>= hue 360)))
      (push (format "Hue value %f must be between 0 and 360" hue) errors))
    (if errors
        (error "Invalid LuvLCh value: %s" (string-join (reverse errors) "; "))
      (set-default symbol value))))
(defcustom hasliberg-theme-dark-or-light 'dark
  "The theme variant, either `dark` or `light`."
  :type '(choice (const :tag "Dark" dark)
                 (const :tag "Light" light))
  :group 'hasliberg-theme
  :set (lambda (symbol value)
         (set-default symbol value)
         (hasliberg-theme--update))
  :initialize 'custom-initialize-default)

(defcustom hasliberg-theme-colour-background
  '(:luminance 17.877  :chroma  1.800  :hue 236.421)    ;; #2A2C2E
  "The background colour, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-background-variant
  '(:luminance  6.265  :chroma 11.827  :hue 252.428)    ;; #00142D
  "Another background colour with slight variation, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-neutral
  '(:luminance 95.074  :chroma 12.330  :hue 252.652)    ;; #ECF1FF
  "The neutral / default font colour, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-primary
  '(:luminance 80.335  :chroma 40.438  :hue 241.234)    ;; #A7CBF1
  "The primary font colour, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-secondary
  '(:luminance 63.743  :chroma 48.347  :hue 251.617)    ;; #809BCE
  "The secondary font colour, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-accent
  '(:luminance 77.610  :chroma 86.648  :hue  47.245)    ;; #FBB151
  "The accent font colour, used sparingly for call-to-action, etc., in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-accent-variant
  '(:luminance 67.236  :chroma 86.052  :hue 335.603)    ;; #FB74C3
  "Another accent font colour with slight variation, used sparingly for call-to-action, etc., in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-subtle
  '(:luminance 77.751  :chroma 14.617  :hue 235.776)    ;; #B4C2CF
  "The subtle font colour to slightly mix up, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-subtle-variant
  '(:luminance 73.823  :chroma 11.749  :hue 180.830)    ;; #A4BAB7
  "Another subtle font colour with slight variation to mix up even more, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-info
  ;; '(:luminance 62.814  :chroma 70.124  :hue 123.247)    ;; #5AAA46
  '(:luminance 71.365 :chroma 21.506 :hue 257.597)      ;; #A8AEC7
  "The info font colour, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defcustom hasliberg-theme-colour-warning
  '(:luminance 67.236  :chroma 86.052  :hue 335.603)    ;; #FB74C3
  "The warning font colour, in LuvLCh values."
  :type hasliberg-theme-lch-type
  :set 'hasliberg-theme--validate-and-set-lch
  :group 'hasliberg-theme)
(defun hasliberg-theme-use-dark-standard-colour-palette ()
  "Use dark standard colour palette for Hasliberg Theme setup."
  (interactive)
  (setopt
   hasliberg-theme-dark-or-light 'dark
   hasliberg-theme-colour-background '(:luminance 17.877  :chroma  1.800  :hue 236.421)         ;; #2A2C2E
   hasliberg-theme-colour-background-variant '(:luminance  6.265  :chroma 11.827  :hue 252.428) ;; #00142D
   hasliberg-theme-colour-neutral '(:luminance 95.074  :chroma 12.330  :hue 252.652)            ;; #ECF1FF
   hasliberg-theme-colour-primary '(:luminance 80.335  :chroma 40.438  :hue 241.234)            ;; #A7CBF1
   hasliberg-theme-colour-secondary '(:luminance 63.743  :chroma 48.347  :hue 251.617)          ;; #809BCE
   hasliberg-theme-colour-accent '(:luminance 77.610  :chroma 86.648  :hue  47.245)             ;; #FBB151
   hasliberg-theme-colour-accent-variant '(:luminance 67.236  :chroma 86.052  :hue 335.603)     ;; #FB74C3
   hasliberg-theme-colour-subtle '(:luminance 77.751  :chroma 14.617  :hue 235.776)             ;; #B4C2CF
   hasliberg-theme-colour-subtle-variant '(:luminance 73.823  :chroma 11.749  :hue 180.830)     ;; #A4BAB7
   hasliberg-theme-colour-info '(:luminance 62.814  :chroma 70.124  :hue 123.247)               ;; #5AAA46
   hasliberg-theme-colour-warning '(:luminance 67.236  :chroma 86.052  :hue 335.603)            ;; #FB74C3
   )
  (hasliberg-theme--update)
  )
(defun hasliberg-theme-use-dark-orange-colour-palette ()
  "Use dark standard colour palette for Hasliberg Theme setup."
  (interactive)
  (setopt
   hasliberg-theme-dark-or-light 'dark
   hasliberg-theme-colour-background '(:luminance 17.877  :chroma  1.800  :hue 236.421)         ;; #2A2C2E
   hasliberg-theme-colour-background-variant '(:luminance  6.265  :chroma 11.827  :hue 252.428) ;; #00142D
   hasliberg-theme-colour-neutral '(:luminance 95.074  :chroma 12.330  :hue 252.652)            ;; #ECF1FF
   hasliberg-theme-colour-primary '(:luminance 80.335  :chroma 40.438  :hue  41.234)            ;; #EBBEA1
   hasliberg-theme-colour-secondary '(:luminance 63.743  :chroma 48.347  :hue  51.617)          ;; #BB9362
   hasliberg-theme-colour-accent '(:luminance 77.610  :chroma 86.648  :hue  47.245)             ;; #FBB151
   hasliberg-theme-colour-accent-variant '(:luminance 67.236  :chroma 86.052  :hue  35.603)     ;; #E78E4B
   hasliberg-theme-colour-subtle '(:luminance 77.751  :chroma 14.617  :hue  35.776)             ;; #CFBCB4
   hasliberg-theme-colour-subtle-variant '(:luminance 73.823  :chroma 11.749  :hue  80.830)     ;; #B8B6A7
   hasliberg-theme-colour-info '(:luminance 62.814  :chroma 70.124  :hue  23.247)               ;; #D9816A
   hasliberg-theme-colour-warning '(:luminance 67.236  :chroma 86.052  :hue  35.603)            ;; #E78E4B
   )
  (hasliberg-theme--update)
  )
(defun hasliberg-theme-use-dark-monotonic-colour-palette ()
  "Use dark standard colour palette for Hasliberg Theme setup."
  (interactive)
  (setopt
   hasliberg-theme-dark-or-light 'dark
   hasliberg-theme-colour-background '(:luminance 17.877  :chroma  1.800  :hue 236.421)         ;; #2A2C2E
   hasliberg-theme-colour-background-variant '(:luminance  6.265  :chroma 11.827  :hue 252.428) ;; #00142D
   hasliberg-theme-colour-neutral '(:luminance 95.074  :chroma 12.330  :hue 252.652)            ;; #ECF1FF
   hasliberg-theme-colour-primary '(:luminance 93.380 :chroma 2.848 :hue 192.490)               ;; #E8EDED
   hasliberg-theme-colour-secondary '(:luminance 93.535 :chroma 3.844 :hue 169.497)             ;; #E7EEEC
   hasliberg-theme-colour-accent '(:luminance 76.373 :chroma 32.215 :hue 238.249)               ;; #A1C0DD
   hasliberg-theme-colour-accent-variant '(:luminance 76.373 :chroma 32.215 :hue 238.249)       ;; #A1C0DD
   hasliberg-theme-colour-subtle '(:luminance 77.751  :chroma 14.617  :hue  35.776)             ;; #CFBCB4
   hasliberg-theme-colour-subtle-variant '(:luminance 73.823  :chroma 11.749  :hue  80.830)     ;; #B8B6A7
   hasliberg-theme-colour-info '(:luminance 67.245 :chroma 10.890 :hue 19.862)                  ;; #B1A09E 
   hasliberg-theme-colour-warning '(:luminance 67.236  :chroma 86.052  :hue  35.603)            ;; #E78E4B
   )
  (hasliberg-theme--update)
  )
(defun hasliberg-theme-use-dark-nature-colour-palette ()
  "Use dark standard colour palette for Hasliberg Theme setup."
  (interactive)
  (setopt
   hasliberg-theme-dark-or-light 'dark
   hasliberg-theme-colour-background '(:luminance 17.736 :chroma 13.978 :hue 146.889)           ;; #113122
   hasliberg-theme-colour-background-variant '(:luminance 25.925 :chroma 49.830 :hue 153.821)   ;; #004E24
   hasliberg-theme-colour-neutral '(:luminance 95.146 :chroma 12.143 :hue 253.229)              ;; #ECF1FF
   hasliberg-theme-colour-primary '(:luminance 91.651 :chroma 82.416 :hue 128.406)              ;; #93FF96
   hasliberg-theme-colour-secondary '(:luminance 84.833 :chroma 52.641 :hue 148.810)            ;; #86E7B8
   hasliberg-theme-colour-accent '(:luminance 75.501 :chroma 82.984 :hue 110.610)               ;; #91CB3E
   hasliberg-theme-colour-accent-variant '(:luminance 56.134 :chroma 27.575 :hue 241.601)       ;; #7189A3
   hasliberg-theme-colour-subtle '(:luminance 95.771 :chroma 17.004 :hue 91.625)                ;; #F2F5DE
   hasliberg-theme-colour-subtle-variant '(:luminance 73.828 :chroma 11.880 :hue 80.278)        ;; #B8B6A7
   hasliberg-theme-colour-info '(:luminance 36.998 :chroma 22.023 :hue 101.245)                 ;; #515B3A
   hasliberg-theme-colour-warning '(:luminance 80.484 :chroma 80.188 :hue 67.991)               ;; #E8C547
   )
  (hasliberg-theme--update)
  )
(defun hasliberg-theme-use-light-standard-colour-palette ()
  "Use light standard colour palette for Hasliberg Theme setup."
  (interactive)
  (setopt
   hasliberg-theme-dark-or-light 'light
   hasliberg-theme-colour-background '(:luminance 95.074  :chroma 12.330  :hue 252.652)         ;; #ECF1FF
   hasliberg-theme-colour-background-variant '(:luminance 90.425  :chroma  3.975  :hue 192.174) ;; #DEE5E5
   hasliberg-theme-colour-neutral '(:luminance 17.877  :chroma  1.800  :hue 236.421)            ;; #2A2C2E
   hasliberg-theme-colour-primary '(:luminance 30.335  :chroma 40.438  :hue 241.234)            ;; #024C72
   hasliberg-theme-colour-secondary '(:luminance 13.743  :chroma 48.347  :hue 251.617)          ;; #00256D
   hasliberg-theme-colour-accent '(:luminance 52.814  :chroma 70.124  :hue  23.247)             ;; #BC674E
   hasliberg-theme-colour-accent-variant '(:luminance 17.236  :chroma 86.052  :hue 335.603)     ;; #830052
   hasliberg-theme-colour-subtle '(:luminance 27.751  :chroma 14.617  :hue 235.776)             ;; #324451
   hasliberg-theme-colour-subtle-variant '(:luminance 23.823  :chroma 11.749  :hue 180.830)     ;; #213E3A
   hasliberg-theme-colour-info '(:luminance 12.814  :chroma 70.124  :hue 123.247)               ;; #003000
   hasliberg-theme-colour-warning '(:luminance 17.236  :chroma 86.052  :hue 335.603)            ;; #830052
   )
  (hasliberg-theme--update)
  )

(defun hasliberg-theme--update ()
  "Based on the base colour input, update the shades, faces, and then reload."
  (hasliberg-theme--update-shades)
  (hasliberg-theme--update-all-faces)
  (load-theme 'hasliberg t))
(defvar hasliberg-theme--load-path nil
  "Variable to store the load path of Hasliberg Theme.")
(unless hasliberg-theme--load-path
  (setq hasliberg-theme--load-path load-file-name))

(defun hasliberg-theme-reload ()
  "Re-evaluate the file and reload the config."
  (interactive)
  (load-file hasliberg-theme--load-path)
  (load-theme 'hasliberg t))

(defun hasliberg-theme--lch-to-luv (lch)
  "Convert a colour from LCH to Luv.
LCH is a plist with properties :luminance, :chroma, and :hue."
  (let* ((L (plist-get lch :luminance))
         (C (plist-get lch :chroma))
         (H-degree (plist-get lch :hue))
         ;; Convert degrees to radians
         (H-radians (* pi (/ H-degree 180.0))))
    (list :l L
          :u (* C (cos H-radians))
          :v (* C (sin H-radians)))))
(defun hasliberg-theme--luv-to-xyz (luv)
  "Convert a colour from Luv to XYZ.
Luv is a plist with properties :l, :u and :v."
  (let* ((L (plist-get luv :l))
         (u (plist-get luv :u))
         (v (plist-get luv :v))
         ;; Constants for D65 illuminant
         (ref-u 0.19783000664283)
         (ref-v 0.46831999493879)
         (up (/ (+ u (* 13 L ref-u)) (* 13 L)))
         (vp (/ (+ v (* 13 L ref-v)) (* 13 L)))

         ;; Results
         (Y (if (> L 7.9996)
                (expt (/ (+ L 16) 116.0) 3)
              (/ L 903.3)))
         ;; Ensure `vp` is not zero to avoid division by zero
         (X (if (zerop vp) 0
              (/ (* 9 Y up) (* 4 vp))))
         (Z (if (zerop vp) 0
              (/ (* (- 12 (* 3 up) (* 20 vp)) Y) (* 4 vp)))))
    (list :x (* 100 X) :y (* 100 Y) :z (* 100 Z))))
(defun hasliberg-theme--xyz-to-rgb (xyz)
  "Convert a colour from XYZ to RGB.
XYZ is a plist with properties :x, :y, and :z."
  (let* ((X (/ (plist-get xyz :x) 100.0))
         (Y (/ (plist-get xyz :y) 100.0))
         (Z (/ (plist-get xyz :z) 100.0))
         ;; Linear transformation matrix for sRGB D65
         (R-linear (+ (* X 3.2406) (* Y -1.5372) (* Z -0.4986)))
         (G-linear (+ (* X -0.9689) (* Y 1.8758) (* Z 0.0415)))
         (B-linear (+ (* X 0.0557) (* Y -0.2040) (* Z 1.0570)))
         ;; Apply gamma correction
         (R (if (<= R-linear 0.0031308)
                (* 12.92 R-linear)
              (- (* 1.055 (expt R-linear (/ 1.0 2.4))) 0.055)))
         (G (if (<= G-linear 0.0031308)
                (* 12.92 G-linear)
              (- (* 1.055 (expt G-linear (/ 1.0 2.4))) 0.055)))
         (B (if (<= B-linear 0.0031308)
                (* 12.92 B-linear)
              (- (* 1.055 (expt B-linear (/ 1.0 2.4))) 0.055))))
    ;; Clamp the results to the range [0, 1]
    (list :r (min (max R 0.0) 1.0)
          :g (min (max G 0.0) 1.0)
          :b (min (max B 0.0) 1.0))))
(defun hasliberg-theme--rgb-to-hex (rgb)
  "Convert a colour from RGB to Hex.
RGB is a plist with properties :r, :g, and :b, where each value is in the range [0, 1]."
  (let* ((r (round (* (plist-get rgb :r) 255)))
         (g (round (* (plist-get rgb :g) 255)))
         (b (round (* (plist-get rgb :b) 255))))
    (format "#%02X%02X%02X" r g b)))
(defun hasliberg-theme--lch-to-rgb (lch)
  "Convert a colour from LCH to RGB in Hex.
LCH is a plist with properties :luminance, :chroma, and :hue."
  (let* ((luv (hasliberg-theme--lch-to-luv lch))
         (xyz (hasliberg-theme--luv-to-xyz luv))
         (rgb (hasliberg-theme--xyz-to-rgb xyz)))
    (hasliberg-theme--rgb-to-hex rgb)))
(defun hasliberg-theme--hex-to-rgb (hex)
  "Convert a colour from Hex to RGB.
HEX can be a string in the form \"#RRGGBB\", \"RRGGBB\", \"#RGB\", or \"RGB\"."
  ;; Normalize the hex string by removing a leading #
  (let* ((normalized-hex (if (eq (aref hex 0) ?#)
                             (substring hex 1)
                           hex))
         ;; Expand 3-digit color code to 6-digit format if necessary
         (expanded-hex (if (= (length normalized-hex) 3)
                           (apply 'concat (mapcar (lambda (c) (make-string 2 c)) normalized-hex))
                         normalized-hex)))
    ;; Ensure the string has the correct length of 6 characters
    (when (not (= (length expanded-hex) 6))
      (error "Invalid hex colour format, expected 3 or 6 characters"))
    (list :r (/ (string-to-number (substring expanded-hex 0 2) 16) 255.0)
          :g (/ (string-to-number (substring expanded-hex 2 4) 16) 255.0)
          :b (/ (string-to-number (substring expanded-hex 4 6) 16) 255.0))))
(defun hasliberg-theme--rgb-to-xyz (rgb)
  "Convert a colour from RGB to XYZ.
RGB is a plist with properties :r, :g, and :b,
where each value is in the range [0, 1]."
  (let* ((linearize (lambda (c)
                      (if (<= c 0.04045)
                          (/ c 12.92)
                        (expt (/ (+ c 0.055) 1.055) 2.4))))
         (R-linear (funcall linearize (plist-get rgb :r)))
         (G-linear (funcall linearize (plist-get rgb :g)))
         (B-linear (funcall linearize (plist-get rgb :b))))
    (list :x (* 100 (+ (* R-linear 0.4124) (* G-linear 0.3576) (* B-linear 0.1805)))
          :y (* 100 (+ (* R-linear 0.2126) (* G-linear 0.7152) (* B-linear 0.0722)))
          :z (* 100 (+ (* R-linear 0.0193) (* G-linear 0.1192) (* B-linear 0.9505))))))
(defun hasliberg-theme--xyz-to-luv (xyz)
  "Convert a colour from XYZ to Luv.
XYZ is a plist with properties :x, :y, and :z."
  (let* ((X (/ (plist-get xyz :x) 100.0))
         (Y (/ (plist-get xyz :y) 100.0))
         (Z (/ (plist-get xyz :z) 100.0))
         ;; Constants for D65 illuminant
         (ref-X 0.95047)
         (ref-Y 1.00000)
         (ref-Z 1.08883)
         (ref-u (/ (* 4 ref-X) (+ ref-X (* 15 ref-Y) (* 3 ref-Z))))
         (ref-v (/ (* 9 ref-Y) (+ ref-X (* 15 ref-Y) (* 3 ref-Z))))
         (u (/ (* 4 X) (+ X (* 15 Y) (* 3 Z))))
         (v (/ (* 9 Y) (+ X (* 15 Y) (* 3 Z))))
         (L (if (> Y 0.008856)
                (- (* 116 (expt Y (/ 1.0 3))) 16)
              (* 903.3 Y)))
         (u-prime (* 13 L (- u ref-u)))
         (v-prime (* 13 L (- v ref-v))))
    (list :l L :u u-prime :v v-prime)))
(defun hasliberg-theme--xyz-to-luv (xyz)
  "Convert a colour from XYZ to Luv.
XYZ is a plist with properties :x, :y, and :z."
  (let* ((X (/ (plist-get xyz :x) 100.0))
         (Y (/ (plist-get xyz :y) 100.0))
         (Z (/ (plist-get xyz :z) 100.0))
         ;; Constants for D65 illuminant
         (ref-X 0.95047)
         (ref-Y 1.00000)
         (ref-Z 1.08883)
         (ref-u (/ (* 4 ref-X) (+ ref-X (* 15 ref-Y) (* 3 ref-Z))))
         (ref-v (/ (* 9 ref-Y) (+ ref-X (* 15 ref-Y) (* 3 ref-Z))))
         (u (/ (* 4 X) (+ X (* 15 Y) (* 3 Z))))
         (v (/ (* 9 Y) (+ X (* 15 Y) (* 3 Z))))
         (L (if (> Y 0.008856)
                (- (* 116 (expt Y (/ 1.0 3))) 16)
              (* 903.3 Y)))
         (u-prime (* 13 L (- u ref-u)))
         (v-prime (* 13 L (- v ref-v))))
    (list :l L :u u-prime :v v-prime)))
(defun hasliberg-theme--luv-to-lch (luv)
  "Convert a colour from Luv to LCH.
LUV is a plist with properties :l, :u, and :v."
  (let* ((L (plist-get luv :l))
         (u (plist-get luv :u))
         (v (plist-get luv :v))
         (C (sqrt (+ (* u u) (* v v))))
         (H (atan v u))
         ;; Convert radians to degrees and ensure the hue is positive
         (H-degree (mod (/ (* H 180.0) pi) 360.0))
         (format-3dp (lambda (num)
                       (string-to-number (format "%.3f" num)))))
    (list :luminance (funcall format-3dp L)
          :chroma (funcall format-3dp C)
          :hue (funcall format-3dp H-degree))))
(defun hasliberg-theme--rgb-to-lch (hex)
  "Convert a colour from RGB Hex to LCH in Luv space.
HEX is a string in the form \"#RRGGBB\"."
  (let* ((rgb (hasliberg-theme--hex-to-rgb hex))
         (xyz (hasliberg-theme--rgb-to-xyz rgb))
         (luv (hasliberg-theme--xyz-to-luv xyz)))
    (hasliberg-theme--luv-to-lch luv)))

(defun hasliberg-theme-convert-rgb-selection-to-lch (start end)
  "Convert RGB Hex selection to LCH in Luv space,
and insert after the selection. This can be helpful for setting up
the new base colours, but not strictly necessary."
  (interactive "r")
  (let* ((hex (buffer-substring-no-properties start end))
         (lch (hasliberg-theme--rgb-to-lch hex)))
    (goto-char end)
    (insert
     " "
     (format "'(:luminance %.3f :chroma %.3f :hue %.3f)"
             (plist-get lch :luminance)
             (plist-get lch :chroma)
             (plist-get lch :hue)))))
(defun hasliberg-theme-convert-lch-selection-to-rgb (start end)
  "Convert LCH value selection to RGB Hex,
and insert after the selection. This can be helpful for setting up
the new base colours, but not strictly necessary."
  (interactive "r")
  (let* ((lch-selection (buffer-substring-no-properties start end))
         (lch-string (if (string-prefix-p "'" lch-selection)
                         (substring lch-selection 1)
                       lch-selection))
         (lch (read lch-string))
         (hex (hasliberg-theme--lch-to-rgb lch)))
    (goto-char end)
    (insert " " hex)))

(defvar hasliberg-theme-shades nil
  "All shades for the Hasliberg theme colours based on LuvLCh input.
The values here are not meant to be updated manually.")
(defvar hasliberg-theme-shades-hash (make-hash-table :test 'equal)
  "Hash table of all Hasliberg theme shades for fast lookup.
The values here are not meant to be updated manually.")
(defun hasliberg-theme--generate-lch-shades (base-lch)
  "Generate a list of shades for a given LCH base colour. This takes in the
dark / light theme variable into account, and changes the way it generates
the shades. The higher values (e.g. 600, 700, so on) are meant to provide
more contrast and appear brighter based on the background.

In case of dark background, the higher values would result in brighter, more
white colours. In case of light background, they would result in darker, more
black colours."
  (let* ((l (plist-get base-lch :luminance))
         (c (plist-get base-lch :chroma))
         (h (plist-get base-lch :hue))
         (shades '(50 100 200 300 400 500 600 700 800 900 950))
         (dark-or-light hasliberg-theme-dark-or-light)
         (luminance-steps
          (mapcar (lambda (step)
                    ;; Based on dark or light selection, flip the shades.
                    (if (eq dark-or-light 'dark)
                        (+ l (* (- step 500) 0.1))
                      (- l (* (- step 500) 0.1))))
                    shades)))
    (mapcar
     (lambda (lum)
       (hasliberg-theme--lch-to-rgb
        (list :luminance lum :chroma c :hue h)))
     luminance-steps)))
;; This is a bit manual but working.
(defun hasliberg-theme--generate-all-shades ()
  "Generate all shades for the colours defined with customization with the prefix of `hasliberg-theme-colour-'."
  (let* ((prefix "hasliberg-theme-colour-")
         (pflen (length prefix))
         (customs '(hasliberg-theme-colour-background
                    hasliberg-theme-colour-background-variant
                    hasliberg-theme-colour-neutral
                    hasliberg-theme-colour-primary
                    hasliberg-theme-colour-secondary
                    hasliberg-theme-colour-accent
                    hasliberg-theme-colour-accent-variant
                    hasliberg-theme-colour-subtle
                    hasliberg-theme-colour-subtle-variant
                    hasliberg-theme-colour-info
                    hasliberg-theme-colour-warning))
         (colours (cl-loop for c in customs
                           collect (cons (intern (substring (symbol-name c) pflen))
                                         (symbol-value c)))))
    (mapcar
     (lambda (colour)
       (let* ((name (car colour))
              (base-lch (cdr colour))
              (shades (hasliberg-theme--generate-lch-shades base-lch)))
         `(,name . ,(cl-pairlis '(50 100 200 300 400 500 600 700 800 900 950) shades))))
     colours)))
(defun hasliberg-theme--update-shades ()
  "Update the shades and hash table based on the colour variables."
  (setq hasliberg-theme-shades (hasliberg-theme--generate-all-shades))
  (clrhash hasliberg-theme-shades-hash)
  (cl-loop for (name . shades) in hasliberg-theme-shades
           do (cl-loop for (shade-name . shade-value) in shades
                       do (puthash (format "%s-%s" name shade-name) 
                                   shade-value 
                                   hasliberg-theme-shades-hash))))
(defun hasliberg-theme-hex-for (key)
  "Retrieve the Hex colour using a hashed KEY."
  (gethash (symbol-name key) hasliberg-theme-shades-hash))

;;;;----------------------------------------
;;;   Faces (Fonts)
;;------------------------------------------
(defface oblique-only
  '((t :inherit default
       :slant oblique
       :family "Iosevka Nerd Font Propo"))
  "A custom face only to give oblique look")
(defun hasliberg-theme--update-standard-faces ()
  (custom-theme-set-faces
   'hasliberg
   ;;;;----------------------------------------
   ;;;   Basic Faces
   ;;------------------------------------------
   `(default
     ((t :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'neutral-500))))
   `(bold ((t :weight bold)))
   `(italic
     ((t :inherit (default oblique-only))))
   `(bold-italic ((t :inherit (bold oblique-only))))
   `(link
     ((t :inherit (default oblique-only)
         :foreground ,(hasliberg-theme-hex-for 'neutral-400))))
   `(highlight
     ((t :background ,(hasliberg-theme-hex-for 'background-variant-700))))

   `(cursor ((t :background ,(hasliberg-theme-hex-for 'accent-700))))
   `(region
     ((t :background ,(hasliberg-theme-hex-for 'background-700)
         :foreground ,(hasliberg-theme-hex-for 'subtle-600))))
   `(secondary-selection
     ((t :background ,(hasliberg-theme-hex-for 'background-variant-600)
         :foreground ,(hasliberg-theme-hex-for 'subtle-600))))
   `(whitespace-space ((t :foreground ,(hasliberg-theme-hex-for 'background-600))))
   `(whitespace-tab ((t :foreground ,(hasliberg-theme-hex-for 'background-600))))

   `(isearch ((t :background ,(hasliberg-theme-hex-for 'primary-300))))
   `(success ((t :foreground ,(hasliberg-theme-hex-for 'info-700)
                 )))
   `(warning ((t :foreground ,(hasliberg-theme-hex-for 'warning-500)
                 )))
   `(minibuffer-prompt ((t :foreground ,(hasliberg-theme-hex-for 'primary-500)
                           :weight semibold)))

   ;;;;----------------------------------------
   ;;;   Visual Elements
   ;;------------------------------------------
   ;; Configurations around some standard visual elements such as mode lines.
   ;; These tend to have more complicated configuration, and thus I'm making them
   ;; multiline and make it easier to edit later.
   `(fringe
     ((t :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'accent-100))))
   `(menu
     ((t :background ,(hasliberg-theme-hex-for 'background-300)
         :foreground ,(hasliberg-theme-hex-for 'neutral-500))))
   `(scroll-bar
     ((t :background ,(hasliberg-theme-hex-for 'background-300)
         :foreground ,(hasliberg-theme-hex-for 'neutral-500))))
   `(tool-bar
     ((t :background ,(hasliberg-theme-hex-for 'background-300)
         :foreground ,(hasliberg-theme-hex-for 'neutral-500))))
   `(vertical-border
     ((t :foreground ,(hasliberg-theme-hex-for 'background-300))))
   `(header-line
     ((t :inherit oblique-only
         :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'neutral-300))
      ))
   `(tab-bar
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-500))))
   `(tab-bar-tab
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-500))))
   `(tab-bar-inactive
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-700))))
   `(tab-bar-tab-group-current
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-500)
         :underline t)))
   `(tab-bar-tab-group-inactive
     ((t :foreground ,(hasliberg-theme-hex-for 'secondary-400))))
   
   ;; Border used for posframe.
   `(child-frame-border ((t :background ,(hasliberg-theme-hex-for 'primary-300))))
   ;; Mode Line
   `(mode-line
     ((t :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'neutral-300)
         ;; :overline   ,(hasliberg-theme-hex-for 'accent-500)
         ;; :underline (:color ,(hasliberg-theme-hex-for 'accent-500) :position 0)
         ;; :box nil
         )))
   `(mode-line-active
     ((t :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'neutral-300)
         :overline   ,(hasliberg-theme-hex-for 'neutral-500)
         ;; :underline (:color ,(hasliberg-theme-hex-for 'accent-500) :position 0)
         ;; :box nil
         )))
   `(mode-line-inactive
     ((t :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'neutral-200)
         :underline  nil
         :overline   nil
         ;; :box nil
         )))
   
   ;;;;----------------------------------------
   ;;;   Line Numbers
   ;;------------------------------------------
   ;; Includes display-line-numbers-mode and global variant.

   ;; This needs to inherit `default' in order to scale when using `text-scale-adjust'.
   `(line-number
     ((t :inherit default
         :height 0.85
         :foreground ,(hasliberg-theme-hex-for 'neutral-50))))
   `(line-number-current-line
     ((t :inherit line-number
         :foreground ,(hasliberg-theme-hex-for 'accent-500)
         :weight semibold)))
   `(line-number-major-tick
     ((t :inherit line-number
         :foreground ,(hasliberg-theme-hex-for 'neutral-600))))
   `(line-number-minor-tick
     ((t :inherit line-number)))

   ;;;;----------------------------------------
   ;;;   Font lock
   ;;------------------------------------------
   ;; Accent colour only used sparingly.
   `(font-lock-string-face
     ((t :foreground ,(hasliberg-theme-hex-for 'accent-500)
         :weight thin)))
   ;; Any user defined fields are based on one variant.
   `(font-lock-function-name-face
     ((t :foreground ,(hasliberg-theme-hex-for 'primary-400)
         :weight regular)))
   `(font-lock-variable-name-face
     ((t :foreground ,(hasliberg-theme-hex-for 'primary-400))))
   `(font-lock-constant-face
     ((t :foreground ,(hasliberg-theme-hex-for 'primary-700)
         :weight semibold)))
   `(font-lock-type-face
     ((t :foreground ,(hasliberg-theme-hex-for 'primary-600)
         :weight regular)))
   ;; Any basic fields are based on another variant.
   `(font-lock-keyword-face
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-700)
         :weight semibold)))
   `(font-lock-builtin-face
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-400))))
   `(font-lock-property-name-face
     ((t :foreground ,(hasliberg-theme-hex-for 'secondary-700))))

   `(font-lock-negation-char-face
     ((t :inherit bold
         :foreground ,(hasliberg-theme-hex-for 'secondary-500))))
   `(font-lock-preprocessor-face
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-300))))

   `(font-lock-comment-face
     ((t :inherit (fixed-pitch oblique-only)
         :foreground ,(hasliberg-theme-hex-for 'neutral-200)
         :weight regular)))
   `(font-lock-comment-delimiter-face
     ((t :inherit (fixed-pitch oblique-only)
         :foreground ,(hasliberg-theme-hex-for 'primary-200)
         :weight thin)))
   `(font-lock-doc-face
     ((t :inherit (fixed-pitch oblique-only)
         :foreground ,(hasliberg-theme-hex-for 'info-700))))

   `(font-lock-property-use-face
     ((t :foreground ,(hasliberg-theme-hex-for 'primary-600))))
   `(font-lock-regexp-grouping-backslash
     ((t :inherit bold
         :foreground ,(hasliberg-theme-hex-for 'subtle-variant-500))))
   `(font-lock-regexp-grouping-construct
     ((t :inherit bold
         :foreground ,(hasliberg-theme-hex-for 'subtle-variant-500))))
   `(font-lock-warning-face
     ((t :foreground ,(hasliberg-theme-hex-for 'warning-500))))

   ;;;;----------------------------------------
   ;;;   Org Mode
   ;;------------------------------------------
   `(org-document-title
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-700)
         :family "Medio"
         :height 3.0)))
   `(org-level-1
     ((t :inherit default
         :foreground ,(hasliberg-theme-hex-for 'accent-500)
         :height 1.5)))
   `(org-level-2
     ((t :inherit default
         :foreground ,(hasliberg-theme-hex-for 'accent-600)
         :height 1.25)))
   `(org-level-3
     ((t :inherit default
         :foreground ,(hasliberg-theme-hex-for 'accent-700)
         :height 1.125)))
   `(org-level-4
     ((t :inherit default
         :foreground ,(hasliberg-theme-hex-for 'accent-variant-800)
         :height 1.0625)))
   `(org-level-5
     ((t :inherit default
         :foreground ,(hasliberg-theme-hex-for 'accent-variant-900)
         :height 1.0625)))
   `(org-level-6
     ((t :inherit default
         :foreground ,(hasliberg-theme-hex-for 'accent-variant-900))))
   `(org-special-keyword
     ((t :inherit fixed-pitch
         :weight thin
         :foreground ,(hasliberg-theme-hex-for 'neutral-200))))
   `(org-code
     ((t :inherit fixed-pitch
         :foreground ,(hasliberg-theme-hex-for 'primary-500))))
   `(org-verbatim
     ((t :inherit fixed-pitch
         :background ,(hasliberg-theme-hex-for 'background-400)
         :foreground ,(hasliberg-theme-hex-for 'primary-400))))
   `(org-ellipsis
     ((t :inherit fixed-pitch
         :foreground ,(hasliberg-theme-hex-for 'accent-700)
         :underline nil
         :height 0.7)))
   ;; This sets the line height without affecting font size.
   `(org-hide ((t :height 1.2)))
   ;; For code block, keep the background untouched as it would render strangely
   ;; for line wrap. Instead, use overline and underline to make a clear block.
   `(org-block
     ((t :inherit (fixed-pitch)
         :foreground ,(hasliberg-theme-hex-for 'subtle-variant-500))))
   `(org-block-begin-line
     ((t :inherit (fixed-pitch oblique-only)
         :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'primary-400)
         :overline   ,(hasliberg-theme-hex-for 'background-700)
         :family "Iosevka Nerd Font Mono"
         :height 0.80)))
   `(org-block-end-line
     ((t :inherit (fixed-pitch oblique-only)
         :background ,(hasliberg-theme-hex-for 'background-500)
         :foreground ,(hasliberg-theme-hex-for 'primary-400)
         :underline (:color ,(hasliberg-theme-hex-for 'background-700) :position 0)
         :family "Iosevka Nerd Font Mono"
         :height 0.75)))
   `(org-quote
     ((t :foreground ,(hasliberg-theme-hex-for 'accent-900) :slant oblique :height 1.1)))
   `(org-verse
     ((t :foreground ,(hasliberg-theme-hex-for 'neutral-600))))
   `(org-table
     ((t :inherit fixed-pitch
         :background ,(hasliberg-theme-hex-for 'background-600)
         :foreground ,(hasliberg-theme-hex-for 'neutral-600))))

   `(org-drawer ((t :inherit (fixed-pitch font-lock-comment-face))))
   `(org-property-value ((t :inherit (fixed-pitch font-lock-comment-face))))
   `(org-tag ((t :inherit fixed-pitch :height 0.7)))
   `(org-document-info-keyword
     ((t :inherit fixed-pitch
         :foreground ,(hasliberg-theme-hex-for 'neutral-300)
         :height 0.8)))
   `(org-meta-line ((t :inherit org-document-info-keyword)))
   `(org-checkbox ((t :inherit fixed-pitch :box nil)))

   ;; Todo related handling
   `(org-headline-done ((t :foreground ,(hasliberg-theme-hex-for 'neutral-200))))
   ;; Agenda
   `(org-agenda-structure ((t :foreground ,(hasliberg-theme-hex-for 'primary-500))))
   `(org-agenda-done ((t :foreground ,(hasliberg-theme-hex-for 'neutral-100))))
   `(org-upcoming-deadline ((t :foreground ,(hasliberg-theme-hex-for 'warning-800))))
   `(org-scheduled-today ((t :foreground ,(hasliberg-theme-hex-for 'neutral-500))))
   `(org-scheduled-previously ((t :foreground ,(hasliberg-theme-hex-for 'warning-400))))
   `(org-agenda-structure ((t :foreground ,(hasliberg-theme-hex-for 'primary-200))))
   `(org-agenda-current-time ((t :foreground ,(hasliberg-theme-hex-for 'accent-variant-700))))
   `(org-time-grid ((t :foreground ,(hasliberg-theme-hex-for 'neutral-100))))
   `(org-habit-clear-face ((t :background ,(hasliberg-theme-hex-for 'background-variant-500))))
   `(org-habit-clear-future-face ((t :background ,(hasliberg-theme-hex-for 'background-variant-600))))
   `(org-habit-alert-face ((t :background ,(hasliberg-theme-hex-for 'accent-variant-400))))
   `(org-habit-alert-future-face ((t :background ,(hasliberg-theme-hex-for 'primary-200))))
   `(org-habit-overdue-face ((t :background ,(hasliberg-theme-hex-for 'background-600))))
   `(org-habit-overdue-future-face ((t :background ,(hasliberg-theme-hex-for 'background-600))))
   )
  )
(defun hasliberg-theme--update-echo-buffer ()
  (dolist (buffer (list " *Minibuf-0*" " *Echo Area 0*"
                        " *Minibuf-1*" " *Echo Area 1*"))
    (when (get-buffer buffer)
      (with-current-buffer buffer
        ;; TODO: I should use colour definitions instead.
        (face-remap-add-relative 'default 'font-lock-preprocessor-face))))
  )

;; Third party faces
(defun hasliberg-theme--update-mode-line-faces ()
 (custom-theme-set-faces
  'hasliberg
  ;;;;----------------------------------------
  ;;;   Mode Line
  ;;------------------------------------------
  ;; Doom Mode Line related
  `(doom-modeline-buffer-modified
    ((t :inherit (doom-modeline)
        :foreground ,(hasliberg-theme-hex-for 'accent-600)
        :weight semibold)))
  `(doom-modeline-project-parent-dir
    ((t :inherit (doom-modeline)
        ;; I'm not using 'oblique-only face inheritance, as I don't need
        ;; default face based resize handling.
        :slant oblique
        :family "Iosevka Nerd Font Propo" 
        )))
  )
 )
(defun hasliberg-theme--update-dashboard-faces ()
 (custom-theme-set-faces
  'hasliberg
  ;;;;----------------------------------------
  ;;;   Dashboard
  ;;------------------------------------------
  `(dashboard-banner-logo-title
    ((t :foreground ,(hasliberg-theme-hex-for 'primary-500)
        :weight semibold)))
  `(dashboard-heading
    ((t :foreground ,(hasliberg-theme-hex-for 'primary-600)
        :weight semibold)))
  `(dashboard-footer-face
    ((t :inherit oblique-only
        :foreground ,(hasliberg-theme-hex-for 'primary-800))))
  )
 )
(defun hasliberg-theme--update-org-related-faces ()
 (custom-theme-set-faces
  'hasliberg
  ;;;;----------------------------------------
  ;;;   Org Mode
  ;;------------------------------------------
  ;; Other Org Mode related handling (third party)
  `(org-modern-todo ((t :inherit fixed-pitch
                        :background ,(hasliberg-theme-hex-for 'primary-600))))
  `(org-modern-symbol ((t :inherit fixed-pitch
                          :family "Symbols Nerd Font Mono")))
  )
 )
(defun hasliberg-theme--update-markdown-faces ()
 (custom-theme-set-faces
  'hasliberg
  ;;;;----------------------------------------
  ;;;   Markdown
  ;;------------------------------------------
  ;; I work with markdown only when I have to. Org Mode is my preference,
  ;; and thus all the configurations here are only to inherit from Org Mode.
  `(markdown-header-face-1 ((t :inherit org-level-1)))
  `(markdown-header-face-2 ((t :inherit org-level-2)))
  `(markdown-header-face-3 ((t :inherit org-level-3)))
  `(markdown-header-face-4 ((t :inherit org-level-4)))
  `(markdown-header-face-5 ((t :inherit org-level-5)))
  `(markdown-header-delimiter-face
    ((t :inherit fixed-pitch
        :foreground ,(hasliberg-theme-hex-for 'accent-200)
        :height 1.1)))
  `(markdown-language-keyword-face ((t :inherit org-block)))
  `(markdown-table-face ((t :inherit org-table)))
  `(markdown-pre-face ((t :inherit org-block)))
  `(markdown-html-attr-name-face
    ((t :inherit org-block
        :foreground ,(hasliberg-theme-hex-for 'primary-600))))
  `(markdown-html-attr-value-face
    ((t :inherit org-block
        :foreground ,(hasliberg-theme-hex-for 'primary-800))))
  `(markdown-html-entity-face
    ((t :inherit org-block
        :foreground ,(hasliberg-theme-hex-for 'primary-500))))
  `(markdown-html-tag-delimiter-face
    ((t :inherit org-block
        :foreground ,(hasliberg-theme-hex-for 'primary-300))))
  `(markdown-html-tag-name-face
    ((t :inherit org-block
        :foreground ,(hasliberg-theme-hex-for 'primary-700))))
  )
 )
(defun hasliberg-theme--update-lsp-faces ()
 (custom-theme-set-faces
  'hasliberg
  ;;;;----------------------------------------
  ;;;   LSP
  ;;------------------------------------------
  `(lsp-face-highlight-textual
    ((t :background ,(hasliberg-theme-hex-for 'background-variant-700))))
  `(lsp-headerline-breadcrumb-path-face
    ((t :inherit fixed-pitch
        :foreground ,(hasliberg-theme-hex-for 'primary-500))))
  `(lsp-headerline-breadcrumb-symbols-face
    ((t :inherit fixed-pitch
        :foreground ,(hasliberg-theme-hex-for 'primary-700)
        :weight semibold)))
  )
 )
(defun hasliberg-theme--update-language-specific-faces ()
 (custom-theme-set-faces
  'hasliberg
  ;;;;----------------------------------------
  ;;;   Language Specific Ones
  ;;------------------------------------------
  `(sh-quoted-exec ((t :foreground ,(hasliberg-theme-hex-for 'accent-600))))
  `(sh-heredoc ((t :foreground ,(hasliberg-theme-hex-for 'accent-700))))
  )
 )

(defun hasliberg-theme--update-all-faces ()
  "Update all faces."
  (hasliberg-theme--update-standard-faces)
  (hasliberg-theme--update-echo-buffer)
  (hasliberg-theme--update-mode-line-faces)
  (hasliberg-theme--update-dashboard-faces)
  (hasliberg-theme--update-org-related-faces)
  (hasliberg-theme--update-markdown-faces)
  (hasliberg-theme--update-lsp-faces)
  (hasliberg-theme--update-language-specific-faces)
  )

;;;;----------------------------------------
;;;   Finalise
;;------------------------------------------
(hasliberg-theme--update-shades)
(hasliberg-theme--update-all-faces)
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'hasliberg)
