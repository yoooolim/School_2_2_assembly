	AREA ARMex, CODE, READONLY
		ENTRY
start
	MOV r0,#1 ;1
	LSL r1,r0, #1 ;2
	LSL r2,r0, #3 ;8
	
	ADD r3,r2,r0 ;9
	ADD r3,r3,r1 ;11
	MOV r4,r3
	
	MOV r7,#9
	
Loop
	ADD r3,r3,r1
	ADD r4,r3,r4

Finish
	ADD r6,r6,#1
	CMP r6,r7
	BEQ Endline
	B Loop
	
Endline
	MOV pc,lr
	
	END
	