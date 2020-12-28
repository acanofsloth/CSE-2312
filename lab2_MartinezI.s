@ Code by Ivan Martinez
.global stringCopy
.global stringCat
.global sumS32
.global sumS16
.global sumU32_64
.global countNegative
.global countNonNegative
.global countMatches
.global returnMax
.global returnMin
  
.text

@ void stringCopy(char* strTo, char* strFrom); // copies strFrom to strTo
@	R0	   R0		R1
stringCopy:
	LDRB R2, [R1]
	CMP R2, #0
	BEQ END
	STRB R2, [R0]
	ADD R1, R1, #1
	ADD R0, R0, #1
	B stringCopy
	
@ void stringCat(char* strFrom, char* strTo); // adds strFrom to end of strTo
@	R0	  R0		 R1
stringCat:
	setEnd: 
		LDRB R2, [R1]
		CMP R2, #0
		BEQ catS
		ADD R1, R1, #1
		B setEnd
	catS:
		LDRB R2, [R0]
		CMP R2, #0
		BEQ END
		STRB R2, [R1], #1
		ADD R0, R0, #1
		B catS

@ int32_t sumS32(int32_t x[], int32_t count);
@ 	   R0	  R0	       R1
sumS32:
	MOV R2, R0
	MOV R0, #0
	addLoop1:
		LDR R3, [R2], #4
		ADD R0, R0, R3
		SUBS R1, R1, #1
		BNE addLoop1
		B END

@ int32_t sumS16(int16_t x[], int32_t count);
@	   R0	  R0	       R1
sumS16:
	MOV R2, R0
	MOV R0, #0
	addLoop2:
		LDRH R3, [R2], #2
		ADD R0, R0, R3
		SUBS R1, R1, #1
		BNE addLoop2
		B END

@ uint64_t sumU32_64(uint32_t x[], uint32_t count);
@	    R0:R1     R0	    R1
sumU32_64:
	MOV R2, R0
	MOV R0, #0
	B END

@ uint32_t countNegative (int16_t x[], uint32_t count);
@	    R0  	   R0		R1
countNegative:
	MOV R2, R0
	MOV R0, #0
	checkloop1:
		CMP R1, #0
		BLT END
		LDRH R3, [R2], #2
		SUBS R1, R1, #1
		CMP R3, #0
		BHI checkloop1
		ADD R0, R0, #1
		B checkloop1

@ uint32_t countNonNegative (int16_t x[], uint32_t count);
@ 	    R0		      R0	   R1
countNonNegative:
	MOV R2, R0
	MOV R0, #0
	checkloop2:
		CMP R1, #0
		BLT END
		LDRH R3, [R2], #2
		SUBS R1, R1, #1
		CMP R3, #0
		BLS checkloop2
		ADD R0, R0, #1
		B checkloop2

@ uint32_t countMatches(char str[], char toMatch);
@	    R0		 R0	     R1
countMatches:
	MOV R2, R0
	MOV R0, #0
	matchloop:
		LDRB R3, [R2], #1
		CMP R3, #0
		BEQ END
		CMP R3, R1
		BNE matchloop
		ADD R0, R0, #1
		B matchloop

@ int32_t returnMax(int16_t x[], uint32_t count);
@	   R0	     R0		  R1
returnMax:
	MOV R2, R0
	MOV R0, #0
	maxloop:
		CMP R1, #0
		BLS END
		LDRH R3, [R2], #2
		SUBS R1, R1, #1	
		CMP R3, R0
		BLT lessthan1
		BGE greaterthan1
		B maxloop
	lessthan1:
		MOV R0, R4
		B maxloop
	greaterthan1:
		MOV R0, R3
		B maxloop

@ int32_t returnMin(int16_t x[], uint32_t count);
@	   R0	     R0		  R1
returnMin:
	MOV R2, R0
	MOV R0, #0
	minloop:
		CMP R1, #0
		BLS END
		LDRH R3, [R2], #2
		LDRH R4, [R2]
		SUBS R1, R1, #1	
		CMP R3, R4
		BLT lessthan2
		BGE greaterthan2
		B minloop
	lessthan2:
		MOV R0, R3
		B minloop
	greaterthan2:
		MOV R0, R4
		B minloop

END:
	BX LR
