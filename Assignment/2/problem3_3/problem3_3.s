	AREA ARMex, CODE, READONLY
		ENTRY
start
	MOV r0,#11
	MOV r1,#13
	MOV r2,#15
	MOV r3,#17
	MOV r4,#19
	MOV r5,#21
	MOV r6,#23
	MOV r7,#25
	MOV r8,#27
	MOV r9,#29
	
	ADD r10,r0,r1
	ADD r10,r10,r2
	ADD r10,r10,r3
	ADD r10,r10,r4
	ADD r10,r10,r5
	ADD r10,r10,r6
	ADD r10,r10,r7
	ADD r10,r10,r8
	ADD r10,r10,r9
	
Endline
	MOV pc,lr
	
	END