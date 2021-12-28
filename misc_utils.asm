	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global	debug_value
	global	delay
	global	memory_dead_output_test_jru
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

; determine if the passed memory region has dead output
; params:
;  x = start address
;  y = length
; returns:
; a = (0 = pass, 1 = fail)
memory_dead_output_test_jru:

		; something is wrong with the build process or
		; the .ld file if these don't match
		lda	#RESET_LOWER_BYTE
		cmpa	$ffff
		beq	.fault_reset_lower_byte_passed
		jmp	EA_FAULT_RESET_LOWER_BYTE
	.fault_reset_lower_byte_passed:

	; the 6809 does dummy memory reads of 0xffff
	; when its doesnt need to access the address bus.
	; because of this, reads of memory locations with
	; no/dead output will cause the register to be filled
	; with the lower byte of the reset function's address
	; from the vector table.
	.loop_next_address:
		lda	,x+
		cmpa	#RESET_LOWER_BYTE
		bne	.test_passed

		leay	-1,y
		cmpy	#0
		bne	.loop_next_address

		lda	#1
		JRU_RETURN

	.test_passed:
		clra
		JRU_RETURN

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
