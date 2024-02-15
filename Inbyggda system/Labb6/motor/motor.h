
/*
 * motor.h
 *
 * Created: 2022-12-14 09:50:49
 *  Author: Ibrahim Akiel och Ömer Kolsuz
 */ 

// #define  allows the programmer to give a name to a constant value before the program is compiled. 
// the #ifndef preprocessor directive is used to check if a certain macro is not defined
 
#ifndef MOTOR_H
#define MOTOR_H_ // defining MOTOR_H_H 

#include <inttypes.h>

void motor_init(void);
void motor_set_speed(uint8_t speed);

#endif // MOTOR_H_