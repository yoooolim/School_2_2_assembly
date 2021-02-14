	AREA ARMex, CODE, READONLY
		ENTRY
start
	LDR sp, TEMPADDR1

	MOV r0, #10
	MOV r1, #11
	MOV r2, #12
	MOV r3, #13
	MOV r4, #14
	MOV r5, #15
	MOV r6, #16
	MOV r7, #17
	
	STMEA sp!, {r0-r7}

	MOV r9,#160
	
doRegister
	ADD r0, r0, #0
	ADD r1, r1, #1
	ADD r2, r2, #2
	ADD r3, r3, #3
	ADD r4, r4, #4
	ADD r5, r5, #5
	ADD r6, r6, #6
	ADD r7, r7, #7
	
	ADD r8,r8,r0
	ADD r8,r8,r1
	ADD r8,r8,r2
	ADD r8,r8,r3
	ADD r8,r8,r4
	ADD r8,r8,r5
	ADD r8,r8,r6
	ADD r8,r8,r7
	
doGCD
	CMP r8, r9
	SUBGT r8,r8,r9
	SUBLT r9,r9,r8
	BEQ saveToStack
	B doGCD
	
saveToStack
	LDMEA sp!, {r10}
	ADD r7, r7, r10
	LDMEA sp!, {r10}
	ADD r6, r6, r10
	LDMEA sp!, {r10}
	ADD r5, r5, r10
	LDMEA sp!, {r10}
	ADD r4, r4, r10
	LDMEA sp!, {r10}
	ADD r3, r3, r10
	LDMEA sp!, {r10}
	ADD r2, r2, r10
	LDMEA sp!, {r10}
	ADD r1, r1, r10
	LDMEA sp!, {r10}
	ADD r0, r0, r10
	
	STMEA sp!, {r8}
	STMEA sp!, {r0-r7}
	
endLine
	MOV pc, lr
TEMPADDR1	&	&40000
	END
	

	
	