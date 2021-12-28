	include "ddragon_sound.inc"
	include "ddragon_sound_diag.inc"
	include "error_addresses.inc"
	include "macros.inc"

	global _reset
	global ram_passed

	section reset,"rodata"

_reset:
		; make sure f/irqs are disabled
		orcc	#$50

		; cant use ram at this point so we jump to/back from
		; the ram tests
		jmp	ram_tests
ram_passed:

		; init stack pointer now that ram is considered good
		lds	#((RAM_START + RAM_SIZE) - 1)

		jsr	misc_tests
		jsr	ym2151_tests
		jsr	adpcm_tests

		jmp	EA_ALL_PASSED
