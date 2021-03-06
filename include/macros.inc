
	; JRU/JRU_RETURN (Jump Return U) macros allow for calling a block
	; of code without the need of jsr/stack usage.  This is done by
	; creating a unique label for after the jmp and storing that
	; address in the u register.  When the code block is done it
	; should call the JRU_RETURN macro which will call a jmp to the
	; address in the u register.  JRU <label> will jmp to <label>_jru
	;
	; This is mainly needed early on when we dont know if work ram
	; is working ok.  We do however end up using JRU calls later on
	; to avoid having dupe code for JRU and jsr/rts
 	macro	JRU
		ldu	#.\@
		jmp	\1_jru
.\@
	endm

	macro	JRU_RETURN
		jmp 0,u
	endm

	macro	STALL
.\@
		jmp	.\@
	endm
