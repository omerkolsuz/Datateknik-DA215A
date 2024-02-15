/*
 * delay.inc
 *
 * Author:	Ömer Kolsuz
 *
 * Date:	2022-11-23
 
 */
;==============================================================================
; Delay of 1 µs (including RCALL)
;==============================================================================
delay_1_micros:   // UPPGIFT: komplettera med ett antal NOP-instruktioner!!! 
	NOP				;vi delayer med 1mikrosekund
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
	RET
	

;==============================================================================
; Delay of X µs
;	LDI + RCALL = 4 cycles
;==============================================================================
delay_micros:   // UPPGIFT: komplettera med ett antal NOP-instruktioner!!! 
	; 12 noppar fungerar bra vid längre tillfällen, den första och sista intstructs kör bara 1 gång, så man kan exkludera de från ekvationen om man vill
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
	CPI R24, 0			; more loops to do?
	BRNE delay_micros	;	continue!
	RET

;==============================================================================
; Delay of X ms
;	LDI + RCALL = 4 cycles
;==============================================================================
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
	/*
	NOP                    ; noppar igenom delayen för att skapa pausen
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
	*/
	CPI R18, 0			; more loops to do?
	BRNE loop_dms		;	continue!
	RET
	

