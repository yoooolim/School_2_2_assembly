cr equ 0x0d
	AREA strcpy, CODE, READONLY
		ENTRY
main
	LDR r0, =OriginString 	;get string
	LDR r10, CpyString		;store copied string
	EOR r1, r1, r1			;initialize of r1
	
Loop
	LDRB r2, [r0], #1
	CMP r2, #cr
	BEQ Done
	STRB r2, [r10], #1
	ADD r1, r1, #1
	
	BAL Loop
	
Done
	mov pc, #0	
OriginString DCB "Hello, World", cr
CpyString	&	&4000
	END