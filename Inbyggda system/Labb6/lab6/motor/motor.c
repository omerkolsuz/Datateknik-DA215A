
/*
 * motor.c
 *
 * Created: 2022-12-14 09:51:09
 *  Author: Ibrahim Akiel och Ömer Kolsuz
 */ 

#include <avr/io.h>
#include "motor.h"

void motor_init(void) {
	
	// set PC6 (digital pin 5) as output
	DDRC = 1<<6;
	
	// Set OC3A (PC6) to be cleared on Compare Match (Channel A)
	
	TCCR3A |= 1<<COM3A1;
	// Waveform Generation Mode 5, Fast PWM (8-bit)
	
	TCCR3A |= 1<<WGM30;
	
	TCCR3B |= 1<<WGM32;
	
	// Timer Clock, 16/64 MHz = 1/4 MHz
	
	TCCR3B |= 1<<CS31 | 1<<CS30;
}

void motor_set_speed(uint8_t speed) { // The function that sets the velocity for the motor
	OCR3AH = 0;
	OCR3AL = (speed*255) / 100;			 // The value sends to the timer in order to run the motor
}