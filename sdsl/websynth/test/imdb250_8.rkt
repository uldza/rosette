#lang s-exp rosette

(require (only-in racket/runtime-path define-runtime-path))
(require "../dom.rkt")
(require "../websynth.rkt")
(require "../websynthlib.rkt")

(define-runtime-path html (build-path ".." "html/imdb250.html"))
(define dom (read-DOMNode html))
(define-tags (tags dom))
(define max_zpath_depth (depth dom))

; Record 0 fields
(define-symbolic r0f0zpath tag? [max_zpath_depth])

(define-symbolic r0fieldmask boolean? [max_zpath_depth])
; Record 1 fields
(define-symbolic r1f0zpath tag? [max_zpath_depth])

(define-symbolic r1fieldmask boolean? [max_zpath_depth])
; Record 2 fields
(define-symbolic r2f0zpath tag? [max_zpath_depth])

(define-symbolic r2fieldmask boolean? [max_zpath_depth])
; Record 3 fields
(define-symbolic r3f0zpath tag? [max_zpath_depth])

(define-symbolic r3fieldmask boolean? [max_zpath_depth])
; Record 4 fields
(define-symbolic r4f0zpath tag? [max_zpath_depth])

(define-symbolic r4fieldmask boolean? [max_zpath_depth])
; Record 5 fields
(define-symbolic r5f0zpath tag? [max_zpath_depth])

(define-symbolic r5fieldmask boolean? [max_zpath_depth])
; Record 6 fields
(define-symbolic r6f0zpath tag? [max_zpath_depth])

(define-symbolic r6fieldmask boolean? [max_zpath_depth])
; Record 7 fields
(define-symbolic r7f0zpath tag? [max_zpath_depth])

(define-symbolic r7fieldmask boolean? [max_zpath_depth])

; Cross-record Mask
(define-symbolic recordmask boolean? [max_zpath_depth])
(current-bitwidth 1)

(define (demonstration)

	; Record 0 zpath asserts
	(assert (path? r0f0zpath dom "The Shawshank Redemption"))

	; Record 1 zpath asserts
	(assert (path? r1f0zpath dom "Fight Club"))

	; Record 2 zpath asserts
	(assert (path? r2f0zpath dom "The Big Sleep"))

	; Record 3 zpath asserts
	(assert (path? r3f0zpath dom "In the Mood for Love"))

	; Record 4 zpath asserts
	(assert (path? r4f0zpath dom "The Celebration"))

	; Record 5 zpath asserts
	(assert (path? r5f0zpath dom "The Untouchables"))

	; Record 6 zpath asserts
	(assert (path? r6f0zpath dom "The Bourne Ultimatum"))

	; Record 7 zpath asserts
	(assert (path? r7f0zpath dom "Requiem for a Dream"))

	; Record Mask
	(generate-mask r0f0zpath r1f0zpath recordmask max_zpath_depth))

; Solve
(define (scrape)
	(define sol (solve (demonstration)))

	; Record 0 zpaths
	; Record 1 zpaths
	; Record 2 zpaths
	; Record 3 zpaths
	; Record 4 zpaths
	; Record 5 zpaths
	; Record 6 zpaths
	; Record 7 zpaths

	; Construct final zpaths
	(define r0f0zpath_list (map label (evaluate r0f0zpath)))
	(define generalizelized_r0f0zpath_list 
		(apply-mask r0f0zpath_list (evaluate recordmask)))
	(define field0_zpath (synthsis_solution->zpath generalizelized_r0f0zpath_list))

	(zip 
		(DOM-Flatten (DOM-XPath dom field0_zpath))
	))

(require rackunit rackunit/text-ui)
(define-runtime-path out (build-path "." "imdb250.out"))

(define a-test
	(test-suite 
		"imdb250_8"
		#:before (lambda () (printf "Testing imdb250_8.~n"))
		(test-case "imdb250_8"
			(current-solution (empty-solution))
			(clear-asserts)
			(unsafe-clear-terms!)
			(define expected (second (call-with-input-file out read)))
			(define actual (scrape))
			(check-equal? actual expected))))

(time (run-tests a-test))