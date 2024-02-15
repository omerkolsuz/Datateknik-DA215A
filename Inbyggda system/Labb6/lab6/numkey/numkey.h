﻿/*
 * numkey.h
 *
 * This is the device driver for the numeric keyboard.
 *
 * Author:	Mathias Beckius, Updated by Ibrahim Akiel och Ömer Kolsuz
 *
 * Date:	2022-12-13
 */ 

#ifndef NUMKEY_H_
#define NUMKEY_H_

// a character that represents that no key is pressed!
#define NO_KEY '\0'

void numkey_init(void);
char numkey_read(void);

#endif /* NUMKEY_H_ */