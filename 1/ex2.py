import math
import random
from typing import Tuple

PRIMES = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]


def rsa_numbers(p: int, q: int) -> Tuple[int, int, int]:
    n, phi = p * q, (p - 1) * (q - 1)

    eligible_primes = [i for i in PRIMES if i < phi]

    e = random.choice(eligible_primes)
    while math.gcd(e, phi) != 1:
        e = random.choice(eligible_primes)

    d = pow(e, -1, phi) # multiplicative inverse from 3.8

    return n, e, d


def run():
    p, q = 331, 463
    n, e, d = rsa_numbers(p, q)
    print(f"{p=},{q=},{n=},{e=},{d=}")


if __name__ == '__main__':
    run()
