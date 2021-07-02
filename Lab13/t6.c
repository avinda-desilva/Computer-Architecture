#include "declarations.h"

void
t6(float *restrict A, float *restrict D) {
    for (int nl = 0; nl < ntimes; nl ++) {
        A[0] = 0;
        //#pragma clang loop distribute(enable) --> manually have to do loop fission
        // Try to vectorize
        #pragma clang loop interleave(enable) vectorize(enable)
        for (int i = 0; i < (LEN6 - 3); i ++) {
            A[i] = D[i] + (float) 1.0;

        }
        #pragma clang loop interleave(enable) vectorize(enable)
        // Try to vectorize
        for (int i = 0; i < (LEN6 - 3); i ++) {
            D[i + 3] = A[i] + (float) 2.0;
        }
    }
}
