@ Code by Ivan Martinez
.global sortDecendingInPlace
.global sumF32
.global prodF64
.global dotpF64
.global maxF32
.global absSumF64
.global sqrtSumF64
.global getDirection
.global getAddNo
.global getCity

.text

@ void sortDecendingInPlace(int16_t x[], uint32_t count);
@ R0			     R0		  R1
sortDecendingInPlace:
	MOV R2, #0
	LDRH R2, [R0]
	DIPloop:
		CMP R1, #0 @ test counter
		BEQ END 
		LDRH R3, [R0]
		SUBS R1, R1, #1 @ decrement counter
		CMP R2, R3
		BGE DIPless @ test both numbers
		ADD R0, R0, #2 @ increment array position
		B DIPloop
	DIPless:
		SUB R0, R0, #2
		STRH R3,[R0]
		ADD R0, R0, #2
		STRH R2, [R0]
		ADD R0, R0, #2 @ increment array position
		B DIPloop

@ float sumF32(float x[], uint32_t count);
@ S0		 R0		R1
sumF32:
	MOV R2, #0
	VMOV S0, R2
	FSUMloop:
		CMP R1, #0 @ test counter
		BEQ END
		VLDR.F32 S1, [R0]
		VADD.F32 S0, S0, S1
		SUB R1, R1, #1 @ decrement counter
		ADD R0, R0, #4
		B FSUMloop

@ double prodF64(double x[], uint32_t count);
@ D0		   R0		R1
prodF64:
	VLDR.F64 D0, [R0] @ initialize D0
	ADD R0, R0, #8
	DPRODloop:
		CMP R1, #1 @ test counter
		BEQ END
		VLDR.F64 D1, [R0]
		VMUL.F64 D0, D0, D1
		SUB R1, R1, #1 @ decrement counter
		ADD R0, R0, #8 @ increment array position
		B DPRODloop

@ double dotpF64(double x[], double y[], uint32_t count);
@ D0		   R0	       R1	    R2
dotpF64:
	MOV R3, #0
	VMOV.F64 D0, R3, R3 @ initialize D0 / Set all Zero
	dotpF64loop:
		CMP R2, #0
		BEQ END
		VLDR.F64 D1, [R0]
		VLDR.F64 D2, [R1]
		VMUL.F64 D1, D1, D2
		VADD.F64 D0, D0, D1
		ADD R0, R0, #8
		ADD R1, R1, #8
		SUB R2, R2, #1
		B dotpF64loop

@ float maxF32(float x[], uint32_t count);
@ S0		   R0           R1
maxF32:
	VLDR.F32 S1, [R0]
	ADD R0, R0, #4
	MAXF32loop:
		CMP R1, #1 @ test counter
		BEQ END 
		VLDR.F32 S1, [R0]
		SUB R1, R1, #1
		ADD R0, R0, #4
		VCMP.F32 S0, S1
		BLT Mlessthan
		VMOV.F32 S0, S1
		B MAXF32loop
	Mlessthan:
		VMOV.F32 S0, S1
		B MAXF32loop

@ double absSumF64(double x[], uint32_t count);
@ D0			R0	R1
absSumF64:
	MOV R2, #0 
	VMOV D0, R2, R2	@ initialize D0 / SET ALL ZEROS
	ABSSUMloop:
		CMP R1, #0 @ test counter
		BEQ ABSSUMexit
		VLDR.F64 D1, [R0]
		VADD.F64 D0, D0, D1
		SUB R1, R1, #1 @ decrement counter
		ADD R0, R0, #8 @ increment array position
		B ABSSUMloop
	ABSSUMexit:
		VCVT.F32.F64 S2, D0
		VMOV R2, S2
		CMP R2, #0
		BMI ABSNEG 
		B END
	ABSNEG:
		VMOV.F64 D1, R1, R1
		VSUB.F64 D0, D1, D0
		B END

@ double sqrtSumF64(double x[], uint32_t count);
@ D0		      R0	  R1
sqrtSumF64:
	MOV R3, R1
	MOV R2, #0 
	VMOV D0, R2, R2	@ initialize D0 / SET ALL ZEROS
	DSSUMloop:
		CMP R1, #0 @ test counter
		BEQ DSSUMexit
		VLDR.F64 D1, [R0]
		VADD.F64 D0, D0, D1
		SUB R1, R1, #1 @ decrement counter
		ADD R0, R0, #8 @ increment array position
		B DSSUMloop
	DSSUMexit:
		VMOV.F64 D1, D0
		@VMOV.F64 D0, R2, R2
		VMOV.F64 D2, R2, R2
	@DSQRTloop:
		B END
		
@ 120 bytes in struct total
@ char getDirection (BUSINESS business[], uint32_t index);
@ 	R0		    R0			R1
getDirection:
	MOV R2, R0
	MOV R0, #120
	MUL R1, R1, R0
	ADD R1, R1, #44
	ADD R2, R2, R1
	LDRB R0, [R2]
	B END

@ uint32_t getAddNo (BUSINESS business[], uint32_t index);
@ 	    R0		    R0			R1
getAddNo:
	MOV R2, R0
	MOV R0, #120
	MUL R1, R1, R0
	ADD R1, R1, #40
	ADD R2, R2, R1
	LDR R0, [R2]
	B END

@ char * getCity(BUSINESS business[], uint32_t index);
@ 	  R0	        R0		     R1
getCity:
	MOV R2, #120
	MUL R1, R1, R2
	ADD R1, R1, #78
	ADD R0, R0, R1
	B END

END:
	BX LR
