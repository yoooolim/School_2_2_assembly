	AREA ARMex,CODE,READONLY
		ENTRY
start
	
	MOV r0, #1
	MOV r1, #2
	MOV r2, #3
	MOV r3, #4
	
	LDR r4, TEMPADDR1
	
	STRB r0, [r4]
	STRB r1, [r4,#1]
	STRB r2, [r4,#2]
	STRB r3, [r4,#3]
	
	LDR r5, [r4]
	
	LDR r4, TEMPADDR2
	
	STRB r3, [r4]
	STRB r2, [r4,#1]
	STRB r1, [r4,#2]
	STRB r0, [r4,#3]
	
	LDR r6, [r4]
	
TEMPADDR1	&	&00001000
TEMPADDR2	&	&00001004

	MOV pc, lr

END