#include "declarations.h"

void
t3(float A[LEN3][LEN3]) {
    for (int nl = 0; nl < 1000; nl ++) {
      //#pragma clang loop vectorize(enable) interleave(enable)
        for (int i = 1; i < LEN3; i ++) {
          //#pragma clang loop vectorize(enable) interleave(enable)
            for (int j = 1; j < LEN3; j ++) {
                A[i][j] = A[i - 1][j] + A[i][j - 1];
            }
        }
        A[0][0] ++;
    }
}
