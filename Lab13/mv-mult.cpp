#include "mv-mult.h"
#include <xmmintrin.h>

// Matrix-Vector multiplication
// mat is a SIZE by SIZE matrix, that is arranged in row-column, format,
// That is, you first select a particular row, and then a particular column.
// Each row is laid out as a one-dimensional, array, so if you wanted
// to select a particular row, you would use mat[row].  You can
// also select smaller intervals, by using &mat[row][col].
// The vector is also laid out as a one-dimensional arrow, similar to a row.
// M-V multiplication proceeds by taking the dot product of a matrix row
// with the vector, and doing this for each row in the matrix

// vectorize the below code using SIMD intrinsics
float *
mv_mult_vector(float mat[SIZE][SIZE], float vec[SIZE]) {
    static float ret[SIZE];

    //NEW THINGS
    float inner_product = 0.0, temp[4];  // FROM REFERENCE
    __m128 acc, X, Y;                   // 4x32-bit float registers FROM HANDOUT


    //  UPdated code with SSE intrinsics -- REFERENCE BELOW
    for (int i = 0; i < SIZE; i ++) {
        int j = 0;                      //
        acc = _mm_set1_ps(0.0);         //  NEW THINGS
        ret[i] = 0;                     //
        for (; j < (SIZE - 3); j += 4) {
          X = _mm_loadu_ps(&mat[i][j]);             //
          Y = _mm_loadu_ps(&vec[j]);                //  NEW THINGS
          acc = _mm_add_ps(acc, _mm_mul_ps(X, Y));  //
        }

        _mm_storeu_ps(temp, acc);                           //
        ret[i] += temp[0] + temp[1] + temp[2] + temp[3];   // NEW THINGS

        for (; j < SIZE; j++) {
           ret[i] += mat[i][j] * vec[j];        // NEW THINGS
       }

    }

    return ret;
}

// EXAMPLE FROM LAB  -- REFERENCE

// #include <xmmintrin.h>
// // All SSE instructions and __m128 data type are defined in xmmintrin.h file

//        float x[k]; float y[k]; // operand vectors of length k
//        float inner_product = 0.0, temp[4];
//        __m128 acc, X, Y; // 4x32-bit float registers

//        acc = _mm_set1_ps(0.0); // set all four words in acc to 0.0

//        int i = 0;
//        for (; i < (k - 3); i += 4) {
//        X = _mm_loadu_ps(&x[i]); // load groups of four floats
//        Y = _mm_loadu_ps(&y[i]);
//        acc = _mm_add_ps(acc, _mm_mul_ps(X, Y));
//       }

//        _mm_storeu_ps(temp, acc); // add the accumulated values
//        inner_product = temp[0] + temp[1] + temp[2] + temp[3];

//        for (; i < k; i++) { // add up the remaining floats
//        inner_product += x[i] * y[i];
//      }
