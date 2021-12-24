// prepare primes used as e

static PRIMES: [i32; 20] = [19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 73, 79, 83, 89, 97, 101, 103, 107, 109];

fn extended_eucl_rec(r: &i32, u: i32, v: i32, rp: i32, up: i32, vp: i32,
                     rout: *mut i32, vout: *mut i32, uout: *mut i32) {
    if rp == 0 {
        unsafe {
            *rout = *r;
            *uout = u;
            *vout = v;
        }
        return;
    }

    return extended_eucl_rec(&rp, up, vp,
                             r - (r / rp) * rp, u - (r / rp) * up, v - (r / rp) * vp,
                             rout, vout, uout);
}


fn extended_eucl_iter(a: i32, b: i32, rout: *mut i32, vout: *mut i32, uout: *mut i32) {
    let mut r = a;
    let mut u = 1;
    let mut v = 0;
    let mut rp = b;
    let mut up = 0;
    let mut vp = 1;

    let mut upold = 0;
    let mut vpold = 0;
    let mut rpold = 0;

    while rp != 0 {
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

    unsafe {
        *rout = r;
        *uout = u;
        *vout = v;
    }
}

fn choose_neatly_fitting_prime(n: i32) -> &'static i32 {
    for prime in PRIMES.iter() {
        if prime < &n {
            return prime;
        }
    }

    return &-1;
}

fn power_mod(base: i64, exp: i64, n: i64) -> i64 {
    let mut answer: i64 = 1;
    let mut exp_p = exp;
    let mut base_p = base;

    while exp_p != 0 {
        if exp_p & 1 != 0 {
            answer = (answer * base_p) % n;
        }
        exp_p >>= 1;
        base_p = (base_p * base_p) % n;
    }

    return answer;
}

fn generate_keys(p: i32, q: i32, e: &mut i32, n: &mut i32, d: &mut i32) {
    let np: i32 = p * q;

    let phi_n = (p - 1) * (q - 1);

    let ep = choose_neatly_fitting_prime(phi_n);

    if *ep == -1 {
        *e = -1;
        *n = -1;
        *d = -1;
        return;
    }

    let mut v: i32 = 0;
    let mut dp: i32 = 0;
    let mut r: i32 = 0;
    extended_eucl_rec(ep, 1, 0, phi_n, 0, 1, &mut r, &mut v, &mut dp);

    dp = dp % phi_n;
    if dp < 0 {
        dp += phi_n;
    }

    *e = *ep;
    *n = np;
    *d = dp;
}

fn cipher_message(message: i64, e: i64, n: i64) -> i64 {
    return power_mod(message, e, n);
}

fn decipher_message(encrypted: i64, d: i64, n: i64) -> i64 {
    return power_mod(encrypted, d, n);
}

fn main() {
    let message = 10120;

    let p = 107;
    let q = 109;

    let mut e = 0;
    let mut n = 0;
    let mut d = 0;

    generate_keys(p, q, &mut e, &mut n, &mut d);

    println!("original message is {}", message);
    let encrypted = cipher_message(message, e as i64, n as i64);
    println!("encrypted message is {}", encrypted);
    let decrypted = decipher_message(encrypted, d as i64, n as i64);
    println!("decrypted message is {}", decrypted);
}
