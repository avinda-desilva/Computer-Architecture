#include "mandelbrot.h"
#include <xmmintrin.h>

// cubic_mandelbrot() takes an array of SIZE (x,y) coordinates --- these are
// actually complex numbers x + yi, but we can view them as points on a plane.
// It then executes 200 iterations of f, using the <x,y> point, and checks
// the magnitude of the result; if the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the code below using SIMD intrinsics

// non-SSE version of the code

int *
cubic_mandelbrot_vector(float x[SIZE], float y[SIZE]) {
    static int ret[SIZE];

    // NEW THINGS
    __m128 x_1;
    __m128 x_2;
    __m128 y_1;
    __m128 y_2;

    //float inner_product = 0.0, temp[4];
    float temporary[4];

    for (int i = 0; i < (SIZE - 3); i += 4) {   // FROM LAB
  //x1 = y1 = 0.0;    OLD

        // setting new x1 and y1 to 0.0
        x_1 = _mm_set1_ps(0.0);
        y_1 = _mm_set1_ps(0.0);


        // Run M_ITER iterations
        for (int j = 0; j < M_ITER; j ++) {
            // Calculate x1^2 and y1^2
  //float x1_squared = x1 * x1;   OLD
  //float y1_squared = y1 * y1;   OLD

            // Calculating NEW x1^2 and y1^2
            __m128 x_1_sqaured = _mm_mul_ps(x_1, x_1);
            __m128 y_1_sqaured = _mm_mul_ps(y_1, y_1);

            // Calculate the real piece of (x1 + (y1*i))^3 + (x + (y*i))
  //x2 = x1 * (x1_squared - 3 * y1_squared) + x[i];     OLD

            // New Calculation
            __m128 temp = _mm_set1_ps(3);
            __m128 temp2 = _mm_mul_ps(y_1_sqaured, temp);
            __m128 temp3 = _mm_sub_ps(x_1_sqaured, temp2);
            __m128 temp4 = _mm_mul_ps(temp3, x_1);
            __m128 temp5 = _mm_loadu_ps(&x[i]);
            __m128 final = _mm_add_ps(temp4, temp5);
            x_2 = final;



            // Calculate the imaginary portion of (x1 + (y1*i))^3 + (x + (y*i))
 //y2 = y1 * (3 * x1_squared - y1_squared) + y[i];    OLD

            // New Calculation
            __m128 temp0 = _mm_set1_ps(3);
            __m128 temp6 = _mm_mul_ps(x_1_sqaured, temp0);
            __m128 temp7 = _mm_sub_ps(temp6, y_1_sqaured);
            __m128 temp8 = _mm_mul_ps(y_1, temp7);
            __m128 temp9 = _mm_loadu_ps(&y[i]);
            __m128 final2 = _mm_add_ps(temp8, temp9);
            y_2 = final2;




            // Use the resulting complex number as the input for the next
            // iteration
//x1 = x2;        OLD
//y1 = y2;        OLD

            // NeW input
            x_1 = x_2;
            y_1 = y_2;
        }

        // caculate the magnitude of the result;
        // we could take the square root, but we instead just
        // compare squares
// ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);    OLD

        // NEW magnitude
        __m128 set_Magnitude = _mm_set1_ps(M_MAG);
        __m128 x_2_sqau = _mm_mul_ps(x_2, x_2);
        __m128 y_2_sqau = _mm_mul_ps(y_2, y_2);
        __m128 sumation = _mm_add_ps(x_2_sqau, y_2_sqau);
        __m128 mag_sqaured = _mm_mul_ps(set_Magnitude, set_Magnitude);
        __m128 _compare = _mm_cmplt_ps(sumation, mag_sqaured);
        _mm_storeu_ps(temporary, _compare);

        ret[i] = temporary[0];
        ret[i+1] = temporary[1];
        ret[i+2] = temporary[2];
        ret[i+3] = temporary[3];

    }

    return ret;
}


// FROM LAB HANDOUT

// Useful Intrinsics
// __m128 _mm_loadu_ps(float *)
// __m128 _mm_storeu_ps(float *, __m128)
// __m128 _mm_add_ps(__m128, __m128) // parallel arithmetic ops
// __m128 _mm_sub_ps(__m128, __m128)
// __m128 _mm_mul_ps(__m128, __m128)
// __m128 _mm_cmplt_ps(__m128 a, __m128 b)

// The intrinsic __m128 _mm_cmplt_ps(__m128 a, __m128 b) might be useful to implement
// that comparison, combined with some casting

//


// REFERENCE FORM LAB

// float x[k]; float y[k]; // operand vectors of length k
// float inner_product = 0.0, temp[4];
// __m128 acc, X, Y; // 4x32-bit float registers
// acc = _mm_set1_ps(0.0); // set all four words in acc to 0.0
// int i = 0;
// for (; i < (k - 3); i += 4) {
// X = _mm_loadu_ps(&x[i]); // load groups of four floats
// Y = _mm_loadu_ps(&y[i]);
// acc = _mm_add_ps(acc, _mm_mul_ps(X, Y));
// }
// _mm_storeu_ps(temp, acc); // add the accumulated values
// inner_product = temp[0] + temp[1] + temp[2] + temp[3];
// for (; i < k; i++) { // add up the remaining floats
// inner_product += x[i] * y[i];
// }
