// simply put, rsa encryption algorithm

#include <stdint.h>

void extended_euclidean(int32_t p, int32_t q, int32_t *a, int32_t *u, int32_t *b, int32_t *v) {
    int32_t rem = 0xFFFF;
    int32_t quot = 0;
    int32_t ap;
    while (rem != 0) {
        quot = p / q;
        rem = p - (quot * q);
        p = q;
        q = rem;
    }

}

int main(int argc, const char* argv[]) {
    extended_euclidean(120, 23);
}
