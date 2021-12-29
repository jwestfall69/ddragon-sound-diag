	; vector table that exists at
	; the end of the rom file
	section vectors,"rodata"

	word	handle_swi	; SWI3
	word	handle_swi	; SWI2
	word	handle_firq
	word	handle_irq
	word	handle_swi	; SWI
	word	handle_nmi
	word	handle_reset

