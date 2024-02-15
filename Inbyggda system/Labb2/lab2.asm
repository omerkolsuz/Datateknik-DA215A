/*
 * lab2.asm
 * 
 * This is a very simple demo program made for the course DA215A at
 * Malm� University. The purpose of this program is:
 *	-	To test if a program can be transferred to the ATmega32U4
 *		microcontroller.
 *	-	To provide a base for further programming in "Laboration 1".
 *
 * After a successful transfer of the program, while the program is
 * running, the embedded LED on the Arduino board should be turned on.
 * The LED is connected to the D13 pin (PORTC, bit 7).
 *
 * Author:	Ibrahim Akiel, �mer Kolsuz
 *
 * Date:	2022-11-23
 *
 
*/

	
	;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	.EQU RESET		= 0x0000
	.EQU PM_START	= 0x0056
	.EQU NO_KEY		= 0x0F
	.EQU CONVERT	= 0x30
	.DEF TEMP		= R16
	.DEF RVAL		= R24
	.DEF LVAL		= R17

;==========
;  Skickar instruktionerr till LCD med en 39 mikrosekunds delay after kommandot har exekverats
;=========
	.MACRO LCD_INSTRUCTION ; Skapar en macro till LCD
	LDI R24, @0				; SKpar en parameter f�r r24
	RCALL lcd_write_instr
	LDI R24, 39
	RCALL delay_micros
	.ENDMACRO
;==============================================================================
; Start of program
;==============================================================================
	.CSEG   ;B�jran av bkoden
	.ORG RESET ; R�knaren p�b�rjas genom att �terst�llass till 0 i reset
	RJMP init ; hopppar till init (allts� subrutinen)

	.ORG PM_START  // Detta �r r�knare f�r v�rdet PM_START
	.INCLUDE "delay.inc" // Inkluderar delay.inc
	.INCLUDE "lcd.inc"	// Inkluderar lcd.inc
;==============================================================================
; Basic initializations of stack pointer, I/O pins, etc.
;==============================================================================
init:
	; Set stack pointer to point at the end of RAM.
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	; Initialize pins
	CALL init_pins
	CALL lcd_init   ;kallar p� lcd allts� initierar den
	; Jump to main part of program
	RJMP main

;==============================================================================
; Initialize I/O pins
;==============================================================================
init_pins:

	LDI TEMP, 0xFF ; ser till att TEMP bli tillsatt HIGH
	OUT DDRF, TEMP ;PORT F OUTPUT
	OUT DDRB, TEMP ;PORT B OUTPUT
	OUT DDRD, TEMP ;PORT D OUTPUT

	LDI TEMP, 0x00 ; Ser till att TEMP blir tillsatt till LOW
	OUT DDRE, TEMP ; PORT E INPUTEN

	RET

;==============================================================================
; Main part of program
;==============================================================================
main:
	LCD_WRITE_CHAR 'K'
	LCD_WRITE_CHAR 'E'
	LCD_WRITE_CHAR 'Y'
	LCD_WRITE_CHAR ':'
	LCD_INSTRUCTION 0xC0 ; Ser till att cursorn tills�tts till f�rsta line 1 och rad 0
key_release:
	LDI LVAL, NO_KEY		; Sista v�rdet blir NO_KEY
loop:
	RCALL read_keyboard
	CPI RVAL, NO_KEY
	BREQ key_release	; branchar till key_released IF return v�rdet var NO_KEYY
	CP RVAL, LVAL
	BREQ loop		; Ifall RVAL och LVAL �r lika med brancha till loop
	MOV LVAL, RVAL	; Kopierar v�rt return v�rde till den sista v�rdet
	CPI RVAL, 10	; J�mmf�r RVAL till 10
	BRLO write		; IF RVAL �r l�gre �n 10 hoppar �ver till writee
	LDI TEMP, 7		; 7 Blir addad till nummer 7 eftersom att mellan 9 och A i ASCII �r 7
	ADD RVAL, TEMP
write:
	LDI TEMP, CONVERT
	ADD RVAL, TEMP				; Converterar RVAL till ASCII
	LCD_WRITE_REG_CHAR RVAL
	LDI R24, 250
	RCALL delay_ms
	RJMP loop

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
	LDI R24, 20
	RCALL delay_ms ; delay f�r bounce
	POP R18

	SBIC PINE, 6
	RJMP return_key_val
	INC R18
	CPI R18, 12
	BRNE scan_key
	LDI R18, NO_KEY        ; Ingen key blev tryckt
return_key_val:
	MOV RVAL, R18		;  Kopierar fr�n R18 till RVAL
	RET
