	AREA Project ,CODE, READONLY
		ENTRY
start
	LDR r0, try
	LDR r10, Result_data
	STR r10, [r0]
	
	LDR r10, odd_Result_data
	STR r10, [r0, #4]
	
	LDR r10, =Matrix_data
	ADD r10, #8
	STR r10, [r0, #8]
	
	LDR r10, =Matrix_data
	ADD r10, #4
	STR r10, [r0, #12]
	
	MOV r0, #0
	MOV r10, #0
	MOV r11, #0
	MOV r12, #0
	
	B rolling_setting
	
start2
	LDR r0, try
	LDR r10, Result_data
	STR r10, [r0]
	
	LDR r10, odd_Result_data
	STR r10, [r0, #4]
	
	LDR r10, load_data
	STR r10, [r0, #8]
	
	LDR r10, load_data
	SUB r10, r10, #4
	STR r10, [r0, #12]
	
	MOV r0, #0
	MOV r10, #0
	MOV r11, #0
	MOV r12, #0
	
	B rolling_setting
	
	
rolling_setting
	LDR r1, try
;	STR r0, [r1, #8]
;	STR r10, [r1,#4]
	
	LDR r0, [r1, #12]
	ADD r0, r0, #4
;	LDR r10, =Matrix_data	;length and scale
;	LDR r1, [r0], #4	;length(N)
;	LDR r2, [r1], #4	;interpolation scale(k)
	LDR r10, try
	LDR r10, [r10]

rolling
;	LDR r0, =Matrix_data	;data
;	ADD r0, #8		
;	LDR r10, Result_data
	
	MOV r2, #0xFFFFFF		;calResult loop (i)
	
	MOV r3, #4
	
	LDR r6, [r0]
	STR r6, [r10], #4		;store A
	LDR r9, [r0, #4]
	B calculate
	
odd_rolling_setting		;already store odd_Result_data
	
	MOV r11, #0
	LDR r1, try
	LDR r2, odd_Result_data
	STR r2, [r1,#4]
	STR r0, [r1, #8]
	
	LDR r0, odd_Result_data

	LDR r10, [r1]
	ADD r10, r3
	STR r10, [r1]
	
odd_rolling
	MOV r2, #0xFFFFFF		;calResult loop (i)
	MOV r3, #4
	
	LDR r6, [r0]
	STR r6, [r10], #4
	LDR r9, [r0, #4]
	
calculate
	MOV r4, r6, LSR #31		;S1
	MOV r7, r9, LSR #31		;S2
	
	MOV r5, r6, LSL #1
	MOV r5, r5, LSR #24		;E1
	MOV r8, r9, LSL #1
	MOV r8, r8, LSR #24		;E2
	
	MOV r6, r6, LSL #9
	MOV r6, r6, LSR #9
	ADD r6, r6, #0x800000	;F1
	MOV r9, r9, LSL #9
	MOV r9, r9, LSR #9
	ADD r9, r9, #0x800000	;F2
	
	CMP r4,r7
	BNE judge_result_zero

cal_continue
	CMP r8, r5				;E2-E1
	SUBGT r1, r8, r5
	RSBLE r1, r8, r5		;r1 = shift num
	
	MOVGT r6, r6, LSR r1
	MOVLT r9, r9, LSR r1	;shift right for shift num F whose Exponent is smaller
	
	MOV r1, #0				;initialize
	
	CMP r4, r7				;check sign S1 - S2
	BEQ equalSign
	
	CMP r6, r9				;F1 - F2 ; S1 != S2
	SUBGT r6, r6, r9		
	SUBLE r6, r9, r6		;r6 = F_result_ing
	MOV r9, #1				;initialize of reg9
	
	B calExponent
	
equalSign					;S1 == S2
	ADD r6, r6, r9
	MOV r9, #1
	
calExponent
	CMP r6, r2
	MOVGT r6, r6, LSR #1
	MOVGT r2, #0			;initialize of reg2
	BGT calResult
	SUB r9, r9, #1			;r9 = calResult value1
	MOV r2, r2, LSR #1		;r2 = calExponent loop (i)
	ADD r1, r1, #1			;r1 = calResult value2
	B calExponent
	
calResult
	MOV r6, r6, LSL r1		;F_result
	CMP r5, r8				;E1 - E2
	MOVMI r1, r8			;E2 = r1
	MOVGE r1, r5			;E1 = r1
	ADD r5, r1, r9			;r5 = E_result_ing
	MOV r1, #0				;initialize of reg1	
	MOV r9, #0				;initialize of reg9
	MOV r8, #0				;initailize of reg8
	
	CMP r3, #4
	BEQ store_even
	
	CMP r4, r7
	LDR r1, [r0]
	LDR r9, [r10]
	MOVNE r1, r1, LSL #1
	MOVNE r1, r1, LSR #1
	MOVNE r9, r9, LSL #1
	MOVNE r9, r9, LSR #1
	CMP r1, r9
	MOVLT r4, r7
	MOV r1, #0				;initialize of reg1
	MOV r9, #0				;initialize of reg2
	
	MOV r4, r4, LSL #31		;S_result
	SUB r5, r5, #1			;E_(A+B)/2_result
	MOV r5, r5, LSL #23		;E_result
	MOV r6, r6, LSL #9		
	MOV r6, r6, LSR #9		;F_result

	MOV r2, r4
	ADD r2, r2, r5
	ADD r2, r2, r6			;r2 = result
	
	MOV r4,#0
	MOV r5,#0
	MOV r6,#0
	
	LDR r1, try
	LDR r1, [r1, #4]
	
	STR r2, [r1], #4		;store (A+B)/2
	
	LDR r4, try
	STR r1, [r4,#4]
	MOV r4, #0
	
	LDR r1, =Matrix_data		;for read N
	LDR r2, [r1]			;read N(length)
	MOV r1, #0
	
store_odd_loop
	CMP r1, r13
	BEQ store_odd_loop_end
	ADD r1, r1, #1
	MOV r2, r2, LSL #1
	B store_odd_loop
	
store_odd_loop_end
	SUB r2, r2, #1
	CMP r11, r2
	BEQ odd_rolling_setting			;rolling about odd using odd_Result_data
	
	LDR r6, [r0,#4]!
	LDR r9, [r10,#8]!
	MOV r2, #0xFFFFFF		;calResult loop (i)
	ADD r11, r11, #1
	B calculate
		
store_even	
	CMP r4,r7	;S1 - S2	;if sign is different, check result sign is negative or positive
	LDR r1, [r0], r3
	LDR r9, [r0]
	MOVNE r1, r1, LSL #1
	MOVNE r1, r1, LSR #1
	MOVNE r9, r9, LSL #1
	MOVNE r9, r9, LSR #1
	CMP r1, r9
	MOVLT r4, r7
	MOV r1, #0				;initialize of reg1
	MOV r9, #0				;initialize of reg2
	
	MOV r4, r4, LSL #31		;S_result
	SUB r5, r5, #1			;E_(A+B)/2_result
	MOV r5, r5, LSL #23		;E_result
	MOV r6, r6, LSL #9		
	MOV r6, r6, LSR #9		;F_result

	MOV r2, r4
	ADD r2, r2, r5
	ADD r2, r2, r6			;r2 = result
	
	STR r2, [r10], #4		;store (A+B)/2
	
	MOV r2, #0
	MOV r7, #0
	MOV r8, #0
	
	;calculate r3 = N*r13/2
	LDR r2, =Matrix_data
	LDR r2, [r2]
	MOV r4, #0
	
even_cal_loop
	MOV r2, r2, LSL #1
	CMP r13, r4
	ADD r4, r4, #1
	MOVEQ r4, #0
	BEQ even_cal_loop_end
	B even_cal_loop

even_cal_loop_end
	MOV r2, r2, LSR #1
	SUB r2, r2, #2
	CMP r11, r2
	MOV r2, #0
	MOVEQ r11, #0			;initialize r11
	BEQ padding
	ADD r11, r11, #1
	CMP r12, #1
	BLE which_rolling_loop_end
	MOV r1, r12
	
which_rolling_loop			;odd row or even row?
	MOV r1, r1, LSL #31
	MOV r1, r1, LSR #31
	CMP r1, #1
	BLE which_rolling_loop_end
	B which_rolling_loop

which_rolling_loop_end
	CMP r1, #0
	MOV r1, #0
	BEQ odd_rolling
	B rolling
	
padding
	MOV r11, #0				;initialize column
	LDR r2, [r0]
	STR r2, [r10], #4		;store A
	STR r2, [r10], #4		;padding
	
	LDR r1, =Matrix_data		;for read N
	LDR r2, [r1]
	MOV r4, #0
	
padding_loop1
	MOV r2, r2, LSL #1
	CMP r13, r4
	ADD r4, r4, #1
	MOVEQ r4, #0
	BEQ padding_loop1_end
	B padding_loop1

padding_loop1_end
	MOV r1, #0
	SUB r2, #2
	CMP r2, r12				;check is it over (twice=NxN)
	MOV r2, #0
	BEQ last_row_padding			;twice(NxN)=row is over
	
	CMP r12, #1
	MOV r1, r12
	BLE padding_loop_end
	
padding_loop				;odd row or even row?
	MOV r1, r1, LSL #31
	MOV r1, r1, LSR #31
	
padding_loop_end
	CMP r1,#0
	ADDEQ r12, r12, #1
	BEQ odd_calculate

	ADD r0, #4
	ADD r12, r12, #1
	LDR r1, try
	STR r10, [r1]
	B rolling_setting		;more need for under

last_row_padding
	;calculate r3 = 4*N*r13
	LDR r3, =Matrix_data
	LDR r3, [r3]
	MOV r3, r3, LSL #2		;4 * N
	MOV r4, #0
	
last_row_cal
	ADD r3, r3, r3
	CMP r13, r4
	ADD r4, r4, #1
	MOVEQ r4, #0
	BEQ last_row_cal_end
	B last_row_cal

last_row_cal_end
	LDR r1, try
	LDR r0, [r1]
	
last_row_loop
	CMP r4, r3
	MOVEQ r4, #0
	BEQ checkover
	LDR r1, [r0]
	STR r1, [r0, r3]
	ADD r4, r4, #4
	ADD r0, r0, #4
	B last_row_loop
	
checkover
	MOV r12, #0				;intialize row
	ADD r13, r13, #1
	LDR r1, =Matrix_data		;for read N
	LDR r2, [r1, #4]			;scale
	MOV r1, #0
	CMP r2, r13
	MOVEQ r2, #0	
	BEQ endline
	
	;calculate r3 = 4*N*r13
	LDR r7, =Matrix_data
	LDR r7, [r7]
	MOV r4, #0
	
checkover_loop
	ADD r7, r7, r7
	ADD r4, r4, #1
	CMP r13, r4
	MOVEQ r4, #0
	MOVEQ r8, r7
	SUBEQ r8, r8, #1
	MOVEQ r9, r7
	BEQ checkover_loop_2
	B checkover_loop
	
checkover_loop_2
	ADD r7, r7, r9
	ADD r4, r4, #1
	CMP r8, r4
	MOVEQ r4, #0
	MOVEQ r8, #0
	MOVEQ r9, #0
	BEQ checkover_loop_end
	B checkover_loop_2
	
	
checkover_loop_end
	LDR r0, Result_data
	LDR r1, load_data
	
load
	LDR r5, [r0], #4
	STR r5, [r1], #4
	STR r6, [r1]
	ADD r4, r4, #1
	CMP r4, r7
	BNE load
	BEQ start2

odd_calculate
	LDR r1, try
	STR r0, [r1,#12]
	MOV r1, #0
	;calculate r3 = 4*N*r13
	LDR r3, =Matrix_data
	LDR r3, [r3]
	MOV r3, r3, LSL #2		;4 * N
	MOV r4, #0
	
odd_cal_loop
	MOV r3, r3, LSL #1
	CMP r13, r4
	ADD r4, r4, #1
	MOVEQ r4, #0
	BEQ odd_cal_loop_end
	B odd_cal_loop
	
odd_cal_loop_end
	MOV r2, #0xFFFFFF		;calResult loop (i)
	
	LDR r6, [r0,#4]!
	LDR r9, [r10, -r3]!		;24=4*3*2
	
	B calculate

judge_result_zero
	CMP r5, r8
	BNE cal_continue
	CMP r6, r9
	BNE cal_continue
	MOV r4, #0
	MOV r5, #0
	MOV r6, #0
	MOV r7, #0
	MOV r8, #0
	MOV r9, #0
	B calResult

endline
	MOV PC, LR

odd_Result_data	&	&50000000	;address of odd result

try	&	&40000000

load_data	&	&30000000

	AREA DataArea, DATA
Result_data	&	&60000000	;address of result

Matrix_data
	ALIGN
	DCD 10
	DCD 3
	DCD 2_01000011001000000000000000000000
	DCD 2_11000011100110000000000000000000
	DCD 2_01000011100001000000000000000000
	DCD 2_11000010100000000000000000000000
	DCD 2_01000011100010000000000000000000
	DCD 2_11000000011001000000000000000000
	DCD 2_01000011110101000000000000000000
	DCD 2_11000010000010000000000000000000
	DCD 2_11000000110001000000000000000000
	DCD 2_11000000000100000000000000000000
	DCD 2_00111111101000000000000000000000
	DCD 2_11000011001010000000000000000000
	DCD 2_01000011110100000000000000000000
	DCD 2_11000001101100000000000000000000
	DCD 2_10111111101010000000000000000000
	DCD 2_11000011111101000000000000000000
	DCD 2_00111110111000000000000000000000
	DCD 2_11000010100110000000000000000000
	DCD 2_11000010011000000000000000000000
	DCD 2_01000010010001000000000000000000
	DCD 2_01000000110010000000000000000000
	DCD 2_11000001000100000000000000000000
	DCD 2_01000000010110000000000000000000
	DCD 2_01000000101000000000000000000000
	DCD 2_01000001110100000000000000000000
	DCD 2_01000011000000000000000000000000
	DCD 2_11000011001001000000000000000000
	DCD 2_01000000000000000000000000000000
	DCD 2_11000010000010000000000000000000
	DCD 2_01000100000010000000000000000000
	DCD 2_00111110111100000000000000000000
	DCD 2_10111111000010000000000000000000
	DCD 2_11000010000010000000000000000000
	DCD 2_01000000010010000000000000000000
	DCD 2_11000000011010000000000000000000
	DCD 2_01000100000100000000000000000000
	DCD 2_00111110101100000000000000000000
	DCD 2_11000010001010000000000000000000
	DCD 2_11000010110010000000000000000000
	DCD 2_11000010001101000000000000000000
	DCD 2_01000011100100000000000000000000
	DCD 2_01000010001010000000000000000000
	DCD 2_01000010011000000000000000000000
	DCD 2_00111111001010000000000000000000
	DCD 2_01000010101000000000000000000000
	DCD 2_11000100000101000000000000000000
	DCD 2_01000011111100000000000000000000
	DCD 2_11000011110110000000000000000000
	DCD 2_11000010111100000000000000000000
	DCD 2_01000010010111000000000000000000
	DCD 2_11000001010100000000000000000000
	DCD 2_01000001101010000000000000000000
	DCD 2_10111111001100000000000000000000
	DCD 2_00111111101100000000000000000000
	DCD 2_01000011011100000000000000000000
	DCD 2_11000010010000000000000000000000
	DCD 2_11000001101010000000000000000000
	DCD 2_00111111110000000000000000000000
	DCD 2_01000100000110000000000000000000
	DCD 2_01000010010010000000000000000000
	DCD 2_01000010000010000000000000000000
	DCD 2_11000001010100000000000000000000
	DCD 2_01000010110001000000000000000000
	DCD 2_11000001010111000000000000000000
	DCD 2_11000001011001000000000000000000
	DCD 2_10111110110110000000000000000000
	DCD 2_11000011011000000000000000000000
	DCD 2_01000010101001000000000000000000
	DCD 2_11000000011110000000000000000000
	DCD 2_01000001011110000000000000000000
	DCD 2_00111111100101000000000000000000
	DCD 2_01000001010000000000000000000000
	DCD 2_11000001101000000000000000000000
	DCD 2_01000001101010000000000000000000
	DCD 2_11000001000111000000000000000000
	DCD 2_11000000100101000000000000000000
	DCD 2_11000011111010000000000000000000
	DCD 2_11000011110000000000000000000000
	DCD 2_11000011101100000000000000000000
	DCD 2_10111111001001000000000000000000
	DCD 2_00111110100101000000000000000000
	DCD 2_01000001000010000000000000000000
	DCD 2_01000100010000000000000000000000
	DCD 2_01000001101100000000000000000000
	DCD 2_11000010000000000000000000000000
	DCD 2_11000011110111000000000000000000
	DCD 2_10111110110000000000000000000000
	DCD 2_11000001010111000000000000000000
	DCD 2_00111110101110000000000000000000
	DCD 2_11000100011011000000000000000000
	DCD 2_11000001011110000000000000000000
	DCD 2_01000001000000000000000000000000
	DCD 2_11000010010011000000000000000000
	DCD 2_01000001010100000000000000000000
	DCD 2_11000001000000000000000000000000
	DCD 2_11000011110011000000000000000000
	DCD 2_11000100000111000000000000000000
	DCD 2_11000000001001000000000000000000
	DCD 2_11000100010010000000000000000000
	DCD 2_11000010100000000000000000000000

	END