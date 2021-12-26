	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global	ym2151_tests

	section text


ym2151_tests:

		jsr	busy_bit_test
		tsta
		beq	.busy_bit_passed
		jmp	EA_YM2151_ALREADY_BUSY
	.busy_bit_passed:

		jsr	unexpected_firq

		jsr	timera_test
		tsta
		beq	.timera_passed
		jmp	EA_YM2151_TIMERA
	.timera_passed:

	rts

; we haven't done anything with the ym2151, so the
; busy bit shouldn't be set
; returns:
;  a = (0 = pass, 1 = fail)
busy_bit_test:
		lda	MMIO_YM2151_DATA
		anda	#YM2151_BUSY_BIT
		bne	.test_failed
		clra
		rts

	.test_failed:
		lda	#1
		rts

; see if we get an firq from the ym2151 when
; we haven't configured any timer yet
unexpected_firq:
		clra
		sta	g_firq_expected

		andcc	#$bf

		; firq interrupt handler will
		; generate the error
		ldd	#$1fff
		jsr	delay

		orcc	#$40
		rts

; ddragon sound rom setups up timerA on the
; ym2151 to trigger every ~1ms.  This test
; mimics this and verifies its working by
; confirming we start getting firqs
; returns:
;  a = (0 = pass, 1 = fail)
timera_test:

		; timerA is a 10 bit resolution timer
		; which we setup with CLKA1 and CLKA2
		; registers
		jsr	ym2151_wait_busy
		lda	#YM2151_REG_CLKA1
		sta	MMIO_YM2151_ADDRESS

		jsr	ym2151_wait_busy
		lda	#$f2
		sta	MMIO_YM2151_DATA

		jsr	ym2151_wait_busy
		lda	#YM2151_REG_CLKA2
		sta	MMIO_YM2151_ADDRESS

		jsr	ym2151_wait_busy
		clra
		sta	MMIO_YM2151_DATA

		lda	#1
		sta	g_firq_expected
		clra
		clrb
		std	g_firq_count

		; start timerA and make it generate ints
		jsr	ym2151_wait_busy
		lda	#YM2151_REG_TIMER
		sta	MMIO_YM2151_ADDRESS

		jsr	ym2151_wait_busy
		lda	#$15
		sta	MMIO_YM2151_DATA

		; enable firq
		andcc	#$bf

		; wait a bit
		ldd	#$1fff
		jsr	delay

		; disable firqs
		orcc	#$40

		; disable timerA
		jsr	ym2151_wait_busy
		lda	#YM2151_REG_TIMER
		sta	MMIO_YM2151_ADDRESS

		jsr	ym2151_wait_busy
		clra
		sta	MMIO_YM2151_DATA

		clra
		sta	g_firq_expected

		; see if any firq happened
		ldd	g_firq_count
		cmpd	#0
		beq	.test_failed
		clra
		rts

	.test_failed:
		lda	#1
		rts
