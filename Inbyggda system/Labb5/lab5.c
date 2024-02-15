/*
 * main.c
 *
 * Created: 12/13/2022 8:44:33 AM
 *  Author: Mathias Beckius, Updated by Ömer Kolsuz
 */ 

// include all files necessary for the project
#include <xc.h>
#include <stdio.h>
#include "hmi/hmi.h"
#include "lcd/lcd.h"
#include "delay/delay.h" 040665-7136 
#include "common.h"
#include "temp/temp.h"
#include "numkey/numkey.h"


// declare the three statements in an enum subroutine
enum state {
	SHOW_TEMP_C,
	SHOW_TEMP_F,
	SHOW_TEMP_CF,
};

typedef enum state state_t;

// main method
int main(void)
{
	//  initieringen
	hmi_init();
	numkey_init();
	temp_init();
	char key;
	char temp_str[17]; //lägnden av arrayen storleken är 17 max antal lcd är 16 + 0 
	char str_1[] = "TEMPERATURE:";
	
	
	state_t currentState = SHOW_TEMP_C;
	state_t nextState = SHOW_TEMP_C;
    while(1)
    {
		/*
		Sprintf stands for "string print" and is known as a file handling function
		that is utilized to send formatted output to the string. So instead of sprinting
		on the console, the sprintf() function stores any output on char buffer that is
		specified in sprintf
		*/
		// switch case används för att genera texten som står i sprintf för varje tillstånd
        switch(currentState) {
			case SHOW_TEMP_C:
				sprintf(temp_str, "%u%cC",temp_read_celsius(),0xDF);
				break;
				
			case SHOW_TEMP_F:
				sprintf(temp_str, "%u%cF",temp_read_fahrenheit(),0xDF);
				break;
				
			case SHOW_TEMP_CF:
				sprintf(temp_str,"%u%cC, %u%cF",temp_read_celsius(),0xDF,temp_read_fahrenheit(),0xDF);
				break;
				
		}
			output_msg(str_1, temp_str,5);
			
			key = numkey_read();
			switch(key) {
			
			case '1':
			nextState = SHOW_TEMP_C;
			break;
			case '2':
			nextState = SHOW_TEMP_F;
			break;
			case '3':
			nextState = SHOW_TEMP_CF;
			break;
			default:
			
			break;
		}
	
	
	currentState = nextState;
	

	
	
	}
}
