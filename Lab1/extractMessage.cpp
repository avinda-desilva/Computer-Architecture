/**
* @file
* Contains an implementation of the extractMessage function.
*/

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
  // Length must be a multiple of 8
  assert((length % 8) == 0);
  if (length % 8 != 0) { return NULL;}

  // allocates an array for the output
  char *message_out = new char[length];
  //int width = length / 8;
  int shift = 0;
  for (unsigned i = 0; i < length; i++) {
    if (i % 8 == 0) {
      shift = 0;
    }
    for (unsigned j = 0; j < 8; j++) {
      //char a += message_in[j] & 0x1;
      for (unsigned k = 0; k < 8; k++) {
          unsigned shift_1 = (message_in[8*i+j] >> k);
          message_out[8*i + k] = (shift_1 & 1) << j | message_out[8*i + k];

      }
    }
  }

  return message_out;

}
