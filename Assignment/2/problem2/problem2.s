	AREA ARMex, CODE, READONLY
		ENTRY
start
	LDR r0, =Valuel
	LDR r1, Addressl
	MOV r6, #10
	
Loop
	LDR r2, [r0], #4
	STRB r2, [r1], #-1
	
	ADD r5,r5,#1
	CMP r5,r6
	BEQ Endline
	B Loop
	
Endline
	MOV pc,lr
	
Valuel DCD 10,9,8,7,6,5,4,3,2,1
	
Addressl DCD &00004009
	END