/*
 * temp.h
 *
 * This is the device driver for the LM35 temperature sensor.
 *
 * Author:	Mathias Beckius,Ibrahim Akiel och Ömer Kolsuz
 *
 * Date:	2022-12-13
 */ 

// #define  allows the programmer to give a name to a constant value before the program is compiled.
// the #ifndef preprocessor directive is used to check if a certain macro is not defined

#ifndef TEMP_H_
#define TEMP_H_

#include <inttypes.h>

void temp_init(void);
uint8_t temp_read_celsius(void);
uint8_t temp_read_fahrenheit(void);

#endif /* TEMP_H_ */