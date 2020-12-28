@ Code by Ivan Martinez
.global add32
.global sub64
.global minU16
.global minS32
.global isLessThanU16
.global isLessThanS16
.global shiftLeftU16
.global shiftU32
.global shiftS8
.global isEqualU32
.global isEqualS8

.text

@ uint64_t add32(uint32_t x, uint32_t y); // returns x + y
@ R1:R0			R0	R1
add32:
	ADDS R0, R0, R1
	ADC R1, R0, R1
	BX LR

@ uint64_t sub64(uint64_t x, uint64_t y); // returns x - y
@	   R1:R0  R1:R0       R3:R2
sub64:
	SUBS R0, R2
	SBC R1, R1, R3
	BX LR

@ uint16_t minU16(uint16_t x, uint16_t y); // returns the minimum of x, y
@ 	    R0,	    R0,		R1
minU16:
	CMP R0, R1
	BLT END
	MOV R0, R1
	BX LR

@ int32_t minS32(int32_t x, int32_t y); // returns the minimum of x, y
@	    R0	    R0	       R1
minS32:
	CMP R0, R1
	BLT END
	MOV R0, R1
	BX LR

@ bool isLessThanU16(uint16_t x, uint16_t y); // returns 1 if x < y, 0 else
@ 		R0	R0	   R1
isLessThanU16:
	CMP R0, R1
	MOV R0, #1
	BLT END
	MOV R0, #0
	BX LR

@ bool isLessThanS16(int16_t x, int16_t y); // returns 1 if x < y, 0 else
@ 		R0	R0	   R1
isLessThanS16:
	CMP R0,R1
	MOV R0, #1
	BLT END
	MOV R0, #0
	BX LR

@ uint16_t shiftLeftU16 (uint16_t x, uint16_t p); // returns x << p = x * 2p for p = 0 .. 31
@ 		R0	    R0	   	R1
shiftLeftU16:
	LSL R0, R1
	BX LR

@ uint32_t shiftU32(uint32_t x, int32_t p); // return x * 2p for p = -31 .. 31
@ 	       R0     R0	   R1
shiftU32:
	CMP R1, R1
	
	LSL R0, R1
	BX LR

@ int8_t shiftS8(int8_t x, int8_t p); // return x * 2p for p = -31 .. 31
@ 	   R0      R0        R1
shiftS8:
	CMP R0, R1
	LSL R0, R1
	BX LR

@ bool isEqualU32(uint32_t x, uint32_t y); // returns 1 if x = y, 0 if x != y
@	   R0	    R0		R1
isEqualU32:
	CMP R0, R1
	MOV R0, #1
	BEQ END
	MOV R0, #0
	BX LR

@ bool isEqualS8(int8_t x, int8_t y); // returns 1 if x = y, 0 if x != y
@	   R0	   R0	     R1
isEqualS8:
	CMP R0, R1
	MOV R0, #1
	BEQ END
	MOV R0, #0
	BX LR

END:
	BX LR

