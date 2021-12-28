; global vars
g_firq_count		equ $0000
g_firq_expected		equ $0002

; This is the value we will use when doing the dead output tests.  This
; should also be the value passed to the RESERVE() directive in the .ld
; file.  More details on why this is needed can be found in the
; dead_output_test_jru function.
RESET_LOWER_BYTE	equ $5a
