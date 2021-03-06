;;; timer-tests.el --- tests for timers -*- lexical-binding:t -*-

;; Copyright (C) 2013-2018 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(ert-deftest timer-tests-sit-for ()
  (let ((timer-ran nil)
        ;; Want sit-for behavior when interactive
        (noninteractive nil))
    (run-at-time '(0 0 0 0)
                 nil
                 (lambda () (setq timer-ran t)))
    ;; The test assumes run-at-time didn't take the liberty of firing
    ;; the timer, so assert the test's assumption
    (should (not timer-ran))
    (sit-for 0 t)
    (should timer-ran)))

(ert-deftest timer-tests-debug-timer-check ()
  ;; This function exists only if --enable-checking.
  (if (fboundp 'debug-timer-check)
      (should (debug-timer-check)) t))

(ert-deftest timer-test-multiple-of-time ()
  (should (time-equal-p
	   (timer-next-integral-multiple-of-time '(0 0 0 1) (1+ (ash 1 53)))
	   (list (ash 1 (- 53 16)) 1))))

(ert-deftest timer-next-integral-multiple-of-time-2 ()
  "Test bug#33071."
  (let* ((tc (current-time))
         (tce (encode-time tc 100))
         (nt (timer-next-integral-multiple-of-time tc 0.01))
         (nte (encode-time nt 100)))
    (should (= (car nte) (1+ (car tce))))))

;;; timer-tests.el ends here
