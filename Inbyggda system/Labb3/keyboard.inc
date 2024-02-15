/*
 * keyboard.inc
 *
 *  Created: 2022-11-24 10:26:08
 *   Author: Ibrahim Akiel Ömer Kolsuz
 */

;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	map_table: .DB "147*2580369#"


;==============================================================================
; read_keyboard:
; reads keyboard and returns binaray value. Output R24 
;==============================================================================


read_keyboard:
	LDI R18, 0
scan_key:
	MOV R19, R18
	LSL R19
	LSL R19
	LSL R19
	LSL R19
	
	OUT PORTB, R19
	PUSH R18
	LDI R24, 1
	RCALL delay_ms			; delay for avoiding bounce-effect
	POP R18
	
	SBIC PINE, 6
	RJMP return_key_val
	INC R18	
	CPI R18, 12
	BRNE scan_key
	LDI R18, NO_KEY			; no key was pressed
return_key_val:
	MOV RVAL, R18			; COPY FROM R18 TO RVAL
	RET

key_compare:
    CPI RVAL, NO_KEY
    BREQ key_release		; branch to key_relased if return value was NO_KEY
    CP RVAL, LVAL
    BREQ key_return			; If RVAL and LVAL is equal branch to loop
    MOV LVAL, RVAL			; Copy our return value to last value

;==============================================================================
; key_convert:
; converts from binary to ASCII. Input R24, output R24
;==============================================================================

key_convert:
	LDI ZH, high(map_table <<1)		;Initialize Z pointer
	LDI ZL, low(map_table <<1)
	ADD ZL, RVAL					;Add index
	LDI RVAL, 0x00
	ADC ZH,RVAL						;Add 0 to catch Carry, if present
	LPM RVAL, Z
key_return:
	RET

key_release:
    LDI LVAL, NO_KEY        ; last value is NO_KEY
	RJMP key_return