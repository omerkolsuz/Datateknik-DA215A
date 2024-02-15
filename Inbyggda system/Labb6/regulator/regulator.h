/*
 * regulator.h
 *
 * This is the device driver for the LM35 temperature sensor.
 *
 * Author:	Mathias Beckius,Updated by Ömer Kolsuz
 *
 * Date:	2022-12-14
 */ 

#ifndef TEMP_H_
#define TEMP_H_

#include <inttypes.h>


void regulator_init(void);
uint8_t regulator_read_power(void);

#endif /* TEMP_H_ */
