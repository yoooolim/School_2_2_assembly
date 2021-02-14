	AREA ARMex, CODE, READONLY
		ENTRY
		
start
	LDR r0, TEMPADDR1	;mem that store result
	
	LDR r1, float1
	LDR r2, float2
	
	CMP r1, #0
	BEQ judgeOneZero1
	
	CMP r2, #0
	BEQ judgeOneZero2
	
	MOV r10, #0xFFFFFF
	MOV r11, #1
	
	MOV r3, r1, LSR #31	;S1
	MOV r4, r2, LSR #31	;S2
	
	CMP r3, r4
	BNE judgeZero
Main	
	MOV r5, r1, LSL #1		
	MOV r5, r5, LSR #24	;E1
	
	MOV r6, r2, LSL #1
	MOV r6, r6, LSR #24	;E2
	
	MOV r7, r1, LSL #9
	MOV r7, r7, LSR #9
	ADD r7, r7, #0x800000	;F1
	
	MOV r8, r2, LSL #9
	MOV r8, r8, LSR #9
	ADD r8, r8, #0x800000	;F2

	CMP r6, r5
	SUBGT r9, r6, r5
	RSBLE r9, r6, r5	;r9 = shift num
	
	MOVGT r7, r7, LSR r9
	MOVLT r8, r8, LSR r9
	
	CMP r3, r4
	BEQ equalSign

	CMP r7, r8
	SUBGT r7, r7, r8
	SUBLE r7, r8, r7
	B calExponent
	
equalSign	;When S1 and S2 is same
	ADD r7, r7, r8

calExponent
	CMP r7, r10
	MOVGT r7, r7, LSR #1
	BGT calResult
	SUB r11, r11, #1
	MOV r10, r10, LSR #1
	ADD r12, r12, #1
	B calExponent
	
calResult
	MOV r7, r7, LSL r12
	CMP r5, r6
	MOVMI r12, r6
	MOVGE r12, r5
	ADD r5, r11, r12
	
	CMP r3, r4	;compare two floating points' sign bit
	MOVNE r1, r1, LSL #1
	MOVNE r1, r1, LSR #1
	MOVNE r2, r2, LSL #1
	MOVNE r2, r2, LSR #1
	CMP r1, r2
	MOVLT r3, r4
	
	MOV r3, r3, LSL #31	;SR
	MOV r5, r5, LSL #23	;ER
	MOV r7, r7, LSL #9
	MOV r7, r7, LSR #9	;FR
	
	ADD r8, r3, r5
	ADD r8, r8, r7
	B endline
	
judgeZero
	MOV r5, r1, LSL #1
	MOV r6, r2, LSL #1
	CMP r5, r6
	BNE Main
	MOVEQ r8, #0
	B endline
	
judgeOneZero1
	MOV r8, r2
	B endline

judgeOneZero2
	MOV r8, r1
	
endline
	STR r8, [r0]
	MOV pc, lr

float1	DCD 2_01000010110111000000000000000000
float2	DCD	0x40500000
TEMPADDR1	&	&40000000
TEMPADDR2	&	&4000
	END