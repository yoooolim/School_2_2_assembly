	AREA ARMex, CODE, READONLY
		ENTRY
start
	MOV r0,#1
	LSL r1,r0,#1 ;2
	LSL r2,r0,#3 ;8
	
	ADD r3,r2,r1 ;10
	ADD r4,r3,r3 ;20
	
	MUL r5,r4,r3
	
	END