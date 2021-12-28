	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global	ram_tests

	section	text

ram_tests:
		ldx	#RAM_START
		ldy	#RAM_SIZE
		JRU	memory_dead_output_test
		tsta
		beq	.ram_dead_output_passed
		jmp	EA_RAM_DEAD_OUTPUT

	.ram_dead_output_passed:
		JRU	ram_writable_test
		tsta
		beq	.ram_writable_passed
		jmp	EA_RAM_UNWRITABLE
	.ram_writable_passed:

		lda	#$00
		JRU	ram_data_test
		tsta
		beq	.ram_data_00_passed
		jmp	EA_RAM_DATA
	.ram_data_00_passed:

		lda	#$55
		JRU	ram_data_test
		tsta
		beq	.ram_data_55_passed
		jmp	EA_RAM_DATA
	.ram_data_55_passed:

		lda	#$aa
		JRU	ram_data_test
		tsta
		beq	.ram_data_aa_passed
		jmp	EA_RAM_DATA
	.ram_data_aa_passed:

		lda	#$ff
		JRU	ram_data_test
		tsta
		beq	.ram_data_ff_passed
		jmp	EA_RAM_DATA
	.ram_data_ff_passed:

		JRU	ram_address_test
		tsta
		beq	.ram_address_passed
		jmp	EA_RAM_ADDRESS
	.ram_address_passed:

		jmp	ram_passed

; Read a byte from ram, write !byte back, then re-read it. If
; the re-read byte is the original byte ram is unwritable.
; returns
;  a = (0 = pass, 1 = fail)
ram_writable_test_jru:
		ldx	#RAM_START
		lda	0,x
		tfr	a,b

		coma

		sta	0,x
		cmpb	0,x
		beq	.test_failed

		clra
		JRU_RETURN

	.test_failed:
		lda	#1
		JRU_RETURN

; This tests the supplied byte pattern
; params
;   a = byte to write/read
; return
;   a = (0 = pass, 1 = fail)
ram_data_test_jru:
		ldx	#RAM_START
		ldy	#RAM_SIZE

	.loop_next_address:
		sta	0,x
		cmpa	0,x
		bne	.test_failed

		leax	1,x
		leay	-1,y
		cmpy	#0
		bne	.loop_next_address

		clra
		JRU_RETURN

	.test_failed:
		lda	#1
		JRU_RETURN

; writes an incrementing value at each address line of ram
; then reads them back to verify they match
; returns
;  a = (0 = pass, 1 = fail)
ram_address_test_jru:
		; since ram starts at 0x0000, our test offset
		; is the ram location
		ldx	#RAM_START
		lda	#RAM_ADDRESS_LINES

		; b will contain the data
		ldb	#1

		; write the first one by hand, since
		; rol of 0x0000 is 0x0000
		stb	0,x
		incb
		leax	1,x

	.loop_write_next_address:
		stb	0,x

		; adjust x to be the next address line
		exg	x,d
		rolb
		rola
		exg	d,x

		incb
		deca
		tsta
		bne	.loop_write_next_address


		; now re-read and verify
		ldx	#RAM_START
		lda	#RAM_ADDRESS_LINES

		ldb	#1
		cmpb	0,x
		bne	.test_failed

		incb
		leax	1,x

	.loop_read_next_address:
		cmpb	0,x
		bne	.test_failed

		exg	x,d
		rolb
		rola
		exg	d,x

		incb
		deca
		tsta
		bne	.loop_read_next_address

		clra
		JRU_RETURN

	.test_failed:
		lda	#1
		JRU_RETURN
