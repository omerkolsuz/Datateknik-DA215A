/*
 * delay_asm.s
 *
 * Author:	Ibrahim akiel och �mer kolsuz
 *
 * Date:	2022-12-06
 denna filen anv�nds f�r att f�rdr�ja subrutinerna.
 */ 

 

;==============================================================================
; Delay 1 second
;==============================================================================
	.global delay_1_s
	delay_1_s: 

    LDI R24, 250
    RCALL delay_ms
    LDI R24, 250
    RCALL delay_ms
    LDI R24, 250
    RCALL delay_ms
    LDI R24, 250
    RCALL delay_ms
    RET
	
;=============================================================================
; Delay of 1 �s (including RCALL)
;==============================================================================
.global delay_1_micros
delay_1_micros:   /* UPPGIFT: komplettera med ett antal NOP-instruktioner!!! */
	; 6 NOP:s reqired for 16MHz 1�s highs and lows.
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RET

;==============================================================================
; Delay of X �s
;	LDI + RCALL = 4 cycles
;==============================================================================
.global delay_micros
delay_micros:   /* UPPGIFT: komplettera med ett antal NOP-instruktioner!!! */
	; 12 NOP:s works good for longer times (>3�s)
        ; The first and last instructs only run 1 time, so you can exlude them from the equation.
        ; DEC + CPI + BRNE(false) + nNOP = 2 + 1 + 1 + n = 16.
        ; n = 12  => we need 12 NOP:s for longer times.
    ; 3 NOP:s work good for shorter times (1-3�s)
    ; See generated time graph for microseconds in exel
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DEC R24
	CPI R24, 0			; if there are more loops 
	BRNE delay_micros	;	continue!
	RET

;==============================================================================
; Delay of X ms
;	LDI + RCALL = 4 cycles
;==============================================================================
.global delay_ms
delay_ms:
	MOV R18, R24
loop_dms:
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	DEC R18
	CPI R18, 0			; if there are more loops?
	BRNE loop_dms		;	continue!
	RET