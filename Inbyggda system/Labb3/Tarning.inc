/*
 * Tarning.inc
 *
 *  Created: 2022-11-29 13:52:44
 *   Author: Ömer Kolsuz
 */ 


 ;------------------------------------------------------
 ;Definitions
 ;------------------------------------------------------
roll_dice:
		LDI R16, 6
test: 		NOP
		NOP
		RCALL read_keyboard
		CPI RVAL, 0x04
		BREQ roll
		RET
roll:		DEC R16
		BREQ roll_dice
		RJMP test
