	AREA ARMex, CODE, READONLY
		ENTRY
start
	ldr r0, tempaddr
	mov r1, #10
	add r2, r1, r1, lsl #3			;10*9
	
end