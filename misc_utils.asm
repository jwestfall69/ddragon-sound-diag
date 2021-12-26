	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global	debug_value
	global	delay
	global	ym2151_wait_busy

	section text

; busy loop
; params:
;  d = number of loops (#$ffff is roughly 1 second)
delay:
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		cmpd	#0	; 4 cycles
		subd	#1	; 3 cycles
		bne	delay	; 2 cycles
		rts

; wait for the ym2151 busy bit to go away
; if it takes too long generate a EA_YM2141_BUSY
; error
ym2151_wait_busy:
		pshs	d
		ldd	#$1ff
	.loop_try_again:
		pshs	d
		lda	MMIO_YM2151_DATA
		anda	#YM2151_BUSY_BIT
		beq	.not_busy

		puls	d
		subd	#1
		bne	.loop_try_again

		jmp	EA_YM2151_BUSY

	.not_busy:
		puls	d
		puls	d
		rts

; Jump to $c000 | (a shifted to be the middle 2 nibbles) so
; we can use a logic probe to get the value of a
; params:
;  a = debug value
debug_value:

		tfr	a,b
		clra

		rolb
		rola
		rolb
		rola
		rolb
		rola
		rolb
		rola

		ora	#$c0
		tfr	d,x
		jmp	0,x
