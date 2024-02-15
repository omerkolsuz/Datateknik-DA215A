/*
 * lab1.asm
 * 
 * This is a very simple demo program made for the course DA215A at
 * Malmö University. The purpose of this program is:
 *	-	To test if a program can be transferred to the ATmega32U4
 *		microcontroller.
 *	-	To provide a base for further programming in "Laboration 1".
 *
 * After a successful transfer of the program, while the program is
 * running, the embedded LED on the Arduino board should be turned on.
 * The LED is connected to the D13 pin (PORTC, bit 7).
 *
 * Author:	Mathias Beckius, updated by Magnus Krampell
 *
 * Date:	2014-11-05, 2021-11-17
 *
 */
;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	
	.EQU RESET        = 0x0000
    .EQU PM_START    = 0x0056
    .EQU NO_KEY        = 0x0F
    .EQU CONVERT    = 0x30
    .DEF TEMP        = R16
    .DEF RVAL        = R24
    .DEF LVAL        = R17
	/*
	.EQU RESET		= 0x0000	; ; Detta ger reset värdet 0
	.EQU PM_START	= 0x0056	; ; PM_START ges värdet 0056
	.EQU NO_KEY		= 0x0f		; ; Detta ger värdet 0x0f till NO_KEY
	.DEF TEMP		= R16		; definierar R16 till TEMP
	.DEF RVAL		= R24		; Detta definierar R24 till RVAL
	.DEF CHOICE     = R18		; Definierar R18 till CHoice
	*/
	 
;==============================================================================
; Start of program
;==============================================================================
	.CSEG 			; Böjran av bkoden
	.ORG RESET		; Räknaren påbörjas genom att återställass till 0 i reset
	RJMP init		; hopppar till init (alltså subrutinen)
	.ORG PM_START 	// Detta är räknare för värdet PM_START
	 .INCLUDE "delay.inc" ; Inkluderar  delay
	 .INCLUDE "lcd.inc"	  ; inkluderar lcd
;==============================================================================
; Basic initializations of stack pointer, I/O pins, etc.
;==============================================================================
init:
	 ; Set stack pointer to point at the end of RAM.
	LDI TEMP, LOW(RAMEND)
	OUT SPL, TEMP
	LDI TEMP, HIGH(RAMEND)
	OUT SPH, TEMP
	; Initialize pins
	CALL init_pins
	; Jump to main part of program
	CALL lcd_init ; kallar på lcd alltså initierar den
	RJMP main

;==============================================================================
; Initialize I/O pins
;==============================================================================
init_pins:	

	SBI DDRD, 6
	SBI DDRD, 7
	CBI DDRE, 6

	LDI TEMP, 0xFF
	OUT DDRF, TEMP
	OUT DDRB, TEMP

	RET

	LDI TEMP, 0x80	 		;  Vi laddar 0x80 till TEMP genom LDI 
	OUT DDRC, TEMP	 		;  TEMP skrivs ut på DDRC
		
	LDI TEMP, 0xf0	 		; Laddar TEMP med 0xf0, för att göra koden mer läsbar definieras en benämning för värdet 0x0f
	OUT DDRF, TEMP	 		; skriver ut det på DDRF värdet i Temp Värdet 

	OUT PORTF, TEMP 		; Skriver ut till portF värdet Temp

	OUT PORTB, TEMP	 		; Värdet TEMP skrivs till PortB

	OUT DDRB, TEMP	 		; Skriver ut temp i DDRB
	OUT DDRD, TEMP
	
	SBI DDRD, 6			; Utgångar för port 6 i med att vi vill reglera rs signaaler
 	SBI DDRD, 7			; utgångar f ör port 7 i med att vi vill reglera enable signlar
	RET		 
					; återvänder

;==============================================================================
; Main part of program
;==============================================================================

main:	
 /*
	LDI R24, 'H'
	RCALL lcd_write_chr
	LDI R24, 'E'
	RCALL lcd_write_chr
	LDI R24, 'L'
	RCALL lcd_write_chr
	LDI R24, 'L'
	RCALL lcd_write_chr
	LDI R24, 'O'
	RCALL lcd_write_chr
	LDI R24, ' '
	RCALL lcd_write_chr
	LDI R24, 'W'
	RCALL lcd_write_chr
	LDI R24, 'O'
	RCALL lcd_write_chr
	LDI R24, 'R'
	RCALL lcd_write_chr
	LDI R24, 'L'
	RCALL lcd_write_chr
	LDI R24, 'D'
	RCALL lcd_write_chr
	
	loop:
	RJMP loop
	*/
 
	LDI R24, 'K'
	RCALL lcd_write_chr
	LDI R24, 'E'
	RCALL lcd_write_chr
	LDI R24, 'Y'
	RCALL lcd_write_chr
	LDI R24, ':'
	RCALL lcd_write_chr
	
	loop:
	;RJMP loop 
	LDI RVAL, 0xC0  ; Ser till att cursorn kommer på andra raden i början
	RCALL lcd_write_instr ; Kallar på lcd write instr så att instruktionen kan utföras ovanför
	RJMP keyboard_main ; 

keyboard_main:
		CALL scan_keyboard
		RJMP keyboard_main

scan_keyboard:
		LDI CHOICE, RESET  ; Ser till att R18 nollställs då ingen knapp trycks

check_keyboard:
		OUT PORTB, CHOICE
		RCALL delay_micros
		SBIC PINE, 6
		RJMP Write_key
		INC CHOICE
		CPI RVAL, 12
		BRNE check_keyboard
		LDI CHOICE, RESET
		RET

Write_key:
		LSR CHOICE
		LSR CHOICE
		LSR CHOICE
		LSR CHOICE

		
		RCALL delay_ms

		RET


CALL read_keyboard
	LSL RVAL 	 			; Detta flyttar värdet RVAL till vänster 4 gånger
	LSL RVAL
	LSL RVAL
	LSL RVAL
OUT	PORTF, RVAL				; Värdet i RVAL skickas ut i porto
	NOP						; Delay 2 cycles 
	NOP
	RJMP main				; hoppar tillbaka till main

read_keyboard:
	LDI R18, 0				; reset counter

scan_key:
	MOV R19, R18
	LSL R19					; Skiftar vänster 4 gånger
	LSL R19			
	LSL R19
	LSL R19
	OUT PORTB, R19			; set kolumner och rader
	NOP						; Delayer 12 cyklar enligt  våra beräkningar
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
	SBIC PINE, 6			; kollar ifall PINE på 6 är 0 så skippas nästa steg annars fortsätter den ; 
	RJMP return_key_val
	INC R18					; R18 increments with 1
	CPI R18, 12				; 
	BRNE scan_key			; väntar på att knappen blir 0 då den släpps
	LDI R18, NO_KEY			; ingen key var blev tryckt
	
return_key_val:
	MOV RVAL, R18			; R18 kopieras till RVAL
	RET						; återvänder
	
