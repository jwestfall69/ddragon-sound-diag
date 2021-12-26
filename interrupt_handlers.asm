	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global handle_firq
	global handle_irq
	global handle_nmi
	global handle_swi

	section text

; nmi pin is tied to 5V so should never get one
handle_nmi:
		jmp	EA_UNEXPECTED_NMI

; normal interrupt from from the main cpu.  we
; we have no control of when it might happen
; so just ack it and rti
handle_irq:
		pshs	a
		lda	MMIO_MAIN_CPU_LATCH
		puls	a
		rti

; timer from ym2151 triggers this
handle_firq:

		pshs	d
		lda	g_firq_expected
		tsta
		beq	.unexpected_firq

		ldd	g_firq_count
		addd	#1
		std	g_firq_count

		jsr	ym2151_wait_busy
		lda	#YM2151_REG_TIMER
		sta	MMIO_YM2151_ADDRESS

		jsr	ym2151_wait_busy
		lda	#$15
		sta	MMIO_YM2151_DATA

		puls	d
		rti

	.unexpected_firq:
		orcc	#$40
		jmp	EA_UNEXPECTED_FIRQ

; should never happen
handle_swi:
		rti
