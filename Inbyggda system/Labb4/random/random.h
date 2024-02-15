/*
 * random.h
 *
 * These are functions for generating pseudo-number numbers.
 *
 * Author: Mathias Beckius, Updated by Ibrahim Akiel och Ömer Kolsuz
 *
 * Date: 2022-12-13
 */

#ifndef RANDOM_H_
#define RANDOM_H_

#include <inttypes.h>

void random_seed(void);
uint16_t random_get_nr(uint16_t);

#endif /* RANDOM_H_ */