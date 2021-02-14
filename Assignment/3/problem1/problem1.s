	AREA ARMex, CODE, READONLY
		ENTRY
start
	ldr r0, tempaddr
	mov r1, #1
	add r2, r1, lsl #1						;r2=1*2
	add r3, r2, r2, lsl #1					;r3=1*2*(1+2)
	add r4, r3, lsl #2						;r4=1*2*3*4
	add r5, r4, r4, lsl #2					;r5=1*2*3*4*(1+4)
	add r6, r5, lsl #1						
	add r7, r5, lsl #2						
	add r6, r6, r7							;r6=1*2*3*4*5*(2+4)
	rsb r7, r6, r6, lsl #3					;r7=1*2*3*4*5*6*7
	mov r8, r7, lsl #3						;r8=1*2*3*4*5*6*7*8
	add r9, r8, r8, lsl #3					;r9=1*2*3*4*5*6*7*8*(1+8)
	add r10, r9, r9, lsl #3
	add r10, r9, r10
	
	str r10, [r0]
	
	mov pc,lr
	
tempaddr	&	&40000

	end