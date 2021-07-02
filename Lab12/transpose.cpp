#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) {
    int end = SIZE;
    int delta = 31;
    for (int i = 0; i < end; i += delta) {
      for (int j = 0; j < end; j+= delta) {
        for (int x = i; x < min(i+delta, end); x++) { 
          for (int y = j; y < min(j+delta, end); y++) {
            dest[x][y] = src[y][x];
          }
        }
      }
    }

}
