/*
 * stat_data.inc
 *
 *  Created: 2022-11-29 15:18:12
 *   Author: Ömer Kolsuz
 */ 
 .DSEG  ; The following applies to the RAM: 
.ORG  0x100	
Str: .BYTE 7	
.CSEG 



store_stat:
    LDI XH, HIGH(str)
    LDI XL, LOW(str)
    LD R15, X
    INC R15
    ST X, R15    ; INCREASE TOTAL DICE ROLLS, AND STORE IT TO MEMORY

    ADD XL, R16
    LDI R24, 0
    ADC XH, R24
    LD R15,X
    INC R15
    ST X, R15        ; INCREASE SPECIFIC DICE ROLL (Nbr1-6)

    RET

get_stat: ;<skriv kod för rutinen>
	LDI XH, HIGH(Str)
	LDI XL, LOW(Str)
	ADD XL, R24
	LD R24, X
	RET
clear_stat: ;<skriv kod för rutinen> 
	LDI R25, 0
	STS Str, R25
	STS Str+1, R25
	STS Str+2, R25
	STS Str+3, R25
	STS Str+4, R25
	STS Str+5, R25
	STS Str+6, R25
	RET 
