#include <stdio.h>
#include <stdint.h>

static int32_t prime_table[] = {19, 23, 29, 31, 37, 41, 43, 47, 53,
                                59, 61, 73, 79, 83, 89, 97, 101, 103, 107, 109};


void extended_eucl_rec(int32_t r, int32_t u, int32_t v, int32_t rp, int32_t up, int32_t vp,
                       int32_t *rout, int32_t *vout, int32_t *uout) {

    if (rp == 0) {
        *rout = r;
        *uout = u;
        *vout = v;
        return;
    }

    return extended_eucl_rec(rp, up, vp,
                             r - (r / rp) * rp, u - (r / rp) * up, v - (r / rp) * vp,
                             rout, vout, uout);

}

void extended_eucl_iter(int32_t a, int32_t b, int32_t *rout, int32_t *vout, int32_t *uout) {
    int32_t r = a, u = 1, v = 0;
    int32_t rp = b, up = 0, vp = 1;

    int32_t upold = 0, vpold = 0, rpold = 0;

    while (rp != 0) {
        upold = up;
        vpold = vp;
        rpold = rp;
        up = u - (r / rp) * up;
        vp = v - (r / rp) * vp;
        rp = r - (r / rp) * rp;
        r = rpold;
        u = upold;
        v = vpold;
    }

    *rout = r;
    *uout = u;
    *vout = v;
}

int32_t choose_neatly_fitting_prime(int32_t n) {
    const int32_t prime_table_len = sizeof(prime_table) / sizeof(prime_table[0]);
    for (int32_t i = 0; i < prime_table_len; i++) {
        if (prime_table[i] < n) {
            return prime_table[i];
        }
    }

    return -1;
}

int64_t power_mod(int64_t base, int64_t exp, int64_t mod) {
    int64_t answer = 1;

    while (exp) {
        if (exp & 1)
            answer = (answer * base) % mod;
        exp >>= 1;
        base = (base * base) % mod;
    }
    return answer;
}

// generates both public and private keys based on values of p and q
// Note that p and q should be the prime numbers in order for an algorithm to behave correctly, since 
// phi(n) is calculated as follows phi(n) = (p - 1) * (q - 1), i.e 
// assuming that both p and q are primes
void generate_keys(int32_t p, int32_t q, int32_t *e, int32_t *n, int32_t *d) {
    const int32_t np = p * q;
    // phi(n) outputs the number of relatively prime numbers strictly less than n
    // given that p and q are both primes, we have:
    // phi(p * q) = phi(p) * phi(q) => (p - 1) * (q - 1)
    const phi_n = (p - 1) * (q - 1);

    // now, choose number e which is relatively prime in relation to phi(n), but also
    // strictly less than the latter
    int32_t ep = choose_neatly_fitting_prime(phi_n);

    // wonky way to handle error
    if (ep == -1) {
        *e = -1;
        *n = -1;
        *d = -1;
        return;
    }

    // find number d, such that e * d == 1 (mod phi(n)), can be calculated via extended euclidean algorithm
    // 1 = d * e + v * phi(n) => Bezout's theorem
    int32_t v = 0, dp = 0, r = 0;
    extended_eucl_rec(ep, 1, 0, phi_n, 0, 1, &r, &v, &dp);

    dp = dp % phi_n;
    if (dp < 0) {
        dp += phi_n;
    }

    *e = ep;
    *n = np;
    *d = dp;

    return;
}

int64_t cipher_message(int64_t message, int64_t e, int64_t n) {
    return power_mod(message, e, n);
}

int64_t decipher_message(int64_t encrypted, int64_t d, int64_t n) {
    return power_mod(encrypted, d, n);
}

int main(int argc, const char *argv[]) {

    const int64_t message = 10120;

    int32_t p = 107, q = 109;

    int32_t e = 0, n = 0, d = 0;

    generate_keys(p, q, &e, &n, &d);

    const int64_t encrypted = cipher_message(message, (int64_t) e, (int64_t) n);

    const int64_t    orig_message = decipher_message(encrypted, (int64_t) d, (int64_t) n);

    return 0;
}