	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global	adpcm_tests

	section text

adpcm_tests:

		jsr	already_busy_test
		tsta
		beq	.already_busy_passed
		jmp	EA_ADPCM_ALREADY_BUSY
	.already_busy_passed:

		jsr	adpcm1_not_idle_test
		tsta
		beq	.adpcm1_not_idle_passed
		jmp	EA_ADPCM1_IDLE
	.adpcm1_not_idle_passed:

		jsr	adpcm2_not_idle_test
		tsta
		beq	.adpcm2_not_idle_passed
		jmp	EA_ADPCM1_IDLE
	.adpcm2_not_idle_passed:

		rts


; we haven't done any adpcm so both should
; be idle
; returns:
;  a = (0 = pass, 1 = fail)
already_busy_test:
		; bit 0 is adpcm1
		; bit 1 is adpcm1
		; value 0 = busy, 1 = idle
		lda	MMIO_ADPCM_STATUS
		anda	#$3
		cmpa	#$3
		bne	.test_failed
		clra
		rts

	.test_failed:
		lda	#1
		rts

; play a sound with adpcm1 (IC95/21J-6), verify its not idle when
; playing
adpcm1_not_idle_test:

		clra
		sta	MMIO_ADPCM1_START_OFFSET

		lda	#$4
		sta	MMIO_ADPCM1_END_OFFSET

		lda	#$1
		sta	MMIO_ADPCM1_PLAY

		lda	MMIO_ADPCM_STATUS
		sta	MMIO_ADPCM1_STOP

		anda	#$1
		cmpa	#$1
		beq	.test_failed
		clra
		rts

	.test_failed:
		lda	#$1
		rts

; play a sound with adpcm2 (IC94/21J-7), verify its not idle when
; playing
adpcm2_not_idle_test:

		clra
		sta	MMIO_ADPCM2_START_OFFSET

		lda	#$8
		sta	MMIO_ADPCM2_END_OFFSET

		lda	#$1
		sta	MMIO_ADPCM2_PLAY

		lda	MMIO_ADPCM_STATUS
		sta	MMIO_ADPCM2_STOP

		anda	#$2
		cmpa	#$2
		beq	.test_failed
		clra
		rts

	.test_failed:
		lda	#$1
		rts
