
	global all_tests_passed

	section no_errors,"rodata"

; because of our ld file this bra will be at address 0x8000
; which we will use to signal to the user there were no errors
all_tests_passed:
		bra	all_tests_passed
