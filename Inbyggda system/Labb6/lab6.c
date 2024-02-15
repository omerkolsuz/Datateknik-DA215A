/*
 * main.c
 *
 * Created: 12/14/2022 9:19:07 AM
 *  Author: Ömer Kolsuz
 */ 

#include <xc.h>
#include <stdio.h>
#include "delay/delay.h"
#include "hmi/hmi.h"
#include "lcd/lcd.h"
#include "numkey/numkey.h"
#include "regulator/regulator.h"
#include "common.h"
#include "motor/motor.h"


		// we are defining the different statements that we will be using
enum state
{
	MOTOR_ON,
	MOTOR_OFF,
	MOTOR_RUNNING,
};

typedef enum state state_t;

state_t currentState = MOTOR_OFF;  // gives us the current statement to MOTOR_OFF in order to start it in the standard
state_t nextState = MOTOR_OFF;     // gives us the current statement to MOTOR_OFF in order to start it in the standard

char key;  // creates key
char mode_str[17];
char reg_str[17]; // we are creating a temp string with 16 empty and one for the cursor (similar to lab5)



int main(void)
{
	hmi_init();    
	numkey_init();
	regulator_init();
	motor_init();
	
	while(1)
	{
		
		key = numkey_read();
		switch(currentState)  // changes state depending on what the current_state is
		{
			
			case MOTOR_ON:
			if (regulator_read_power() > 0) //  if the velocity is bigger than 0 then motor_running runs
			{
				nextState = MOTOR_RUNNING;
			}
			else if (key == '1')  //looks if button 1 is pressed
			{
				nextState = MOTOR_OFF;  // if button 1 is pressed then the next state is MOTOR_OFF
			}
			sprintf(mode_str, "MOTOR ON");
			break;

			case MOTOR_OFF:
			if(key == '2' && regulator_read_power() == 0) // if button 2 is pressed and velocity is equal to 0
			nextState = MOTOR_ON;
			sprintf(mode_str, "MOTOR OFF");
			motor_set_speed(0); // sets the velocity to off to 0 because its not going to spin then
			break;
			
			case MOTOR_RUNNING:
			motor_set_speed(regulator_read_power());
			if (key == '1')
			nextState= MOTOR_OFF;
			sprintf(mode_str, "MOTOR RUNNING");
			break;
		}
		sprintf(reg_str,"%u%c",regulator_read_power(), '%'); // Using sprintf to write out the reg string+ sign and reads the regulator to reg_str
		output_msg(mode_str,reg_str,0); // writes out the message on lcd with the value in regulator
		currentState = nextState; // the next is the same as the current state in order to loop through untill new button is pressed
	}
}
