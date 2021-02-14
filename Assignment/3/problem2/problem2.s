	AREA ARMex, CODE, READONLY
		ENTRY
start
	ldr r0, tempaddr
	mov r1, #1
	mov r2, #2
	mov r3, #3
	mov r4, #4
	mov r5, #5
	mov r6, #6
	mov r7, #7
	mov r8, #8
	mov r9, #9
	mov r10, #10
	
	mul	r11, r1, r2
	mul r11, r3, r11
	mul r11, r4, r11
	mul r11, r5, r11
	mul r11, r6, r11
	mul r11, r7, r11
	mul r11, r8, r11
	mul r11, r9, r11
	mul r11, r10, r11
	
	str r11, [r0]
	 
	mov pc, lr
	
tempaddr	&	&40000

	end
	
	