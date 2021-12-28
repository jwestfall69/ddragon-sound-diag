	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global	misc_tests

	section text


misc_tests:
		jsr	ic16_dead_output_test
		tsta
		beq	.ic16_dead_output_passed
		jmp	EA_IC16_DEAD_OUTPUT
	.ic16_dead_output_passed:

		rts

; ic16 is a 245 that sits between the sound cpu and
; the latch used to pass a byte from the main cpu, as
; well as getting the status of the pcms.  do a dead
; output test on both mmio locations and if both fail
; return fail
;  a = (0 = pass, 1 = fail)
ic16_dead_output_test:

		ldx	#MMIO_MAIN_CPU_LATCH
		ldy	#1
		JRU	memory_dead_output_test
		tsta
		beq	.test_passed

		ldx	#MMIO_ADPCM_STATUS
		ldy	#1
		JRU	memory_dead_output_test
		tsta
		beq	.test_passed

		lda	#1
		rts

	.test_passed:
		clra
		rts
