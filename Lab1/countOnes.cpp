/**
 * @file
 * Contains an implementation of the countOnes function.
 */
 #include <assert.h>
 #include "extractMessage.h"
 #include <iostream>

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned right_m_1b = 0x55555555;
	unsigned left_m_1b = 0xAAAAAAAA;
	unsigned right_c = input & right_m_1b;
	unsigned left_c = input & left_m_1b;
	unsigned result = (left_c >> 1) + right_c;

	unsigned right_m_2b = 0x33333333;
	unsigned left_m_2b = 0xCCCCCCCC;
	right_c = result & right_m_2b;
	left_c = result & left_m_2b;
	result = (left_c >> 2) + right_c;

	unsigned right_m_4b = 0x0F0F0F0F;
	unsigned left_m_4b = 0xF0F0F0F0;
	right_c = result & right_m_4b;
	left_c = result & left_m_4b;
	result = (left_c >> 4) + right_c;

	unsigned right_m_8b = 0x00FF00FF;
	unsigned left_m_8b = 0xFF00FF00;
	right_c = result & right_m_8b;
	left_c = result & left_m_8b;
	result = (left_c >> 8) + right_c;

	unsigned right_m_16b = 0x0000FFFF;
	unsigned left_m_16b = 0xFFFF0000;
	right_c = result & right_m_16b;
	left_c = result & left_m_16b;
	result = (left_c >> 16) + right_c;


	return result;
}
