from ex2 import rsa_numbers


def encrypt(d, n, to_encrypt):
    return [pow(ord(c), d, n) for c in to_encrypt]


def decrypt(e: int, n: int, to_decrypt):
    decrypted_as_array = [chr(pow(c, e, n)) for c in to_decrypt]

    return ''.join(decrypted_as_array)


def run():
    p = int(input("p:"))
    q = int(input("q:"))

    n, e, d = rsa_numbers(p, q)
    print(f"Pubkey: {e=}, {n=}")
    print(f"Private key: {d=}, {n=}")

    msg = input('Message: ')
    encrypted_message_as_arr = encrypt(d, n, msg)
    encrypted_message = "".join(map(str, encrypted_message_as_arr))

    print(f'Encrypted: {encrypted_message}')

    decrypted_message = decrypt(e, n, encrypted_message_as_arr)
    print(f'Decrypted: {decrypted_message}')


if __name__ == '__main__':
    run()
