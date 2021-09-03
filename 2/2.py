import hashlib
import time
from flask import Flask, request

max_nonce = 2 ** 32  # 4 billion


def proof_of_work(header, difficulty_bits):
    target = 2 ** (256 - difficulty_bits)

    for nonce in range(max_nonce):
        hash_result = hashlib.sha256((str(header) + str(nonce)).encode('utf-8')).hexdigest()

        if int(hash_result, 16) < target:
            print("Success with nonce %d" % nonce)
            print("Hash is %s" % hash_result)
            return (hash_result, nonce)

    print("Failed after %d (max_nonce) tries" % nonce)

    return nonce


app = Flask(__name__)


@app.route('/pow', methods=['GET'])
def get_chain():
    hash_result = ''

    difficulty_bits = request.args.get('difficulty_bits')

    if difficulty_bits is None or difficulty_bits == 0:
        return "difficulty_bits > 0 query param is required"

    difficulty_bits = int(difficulty_bits)

    difficulty = 2 ** difficulty_bits

    print("Difficulty: %ld (%d bits)" % (difficulty, difficulty_bits))

    print("Starting search...")

    start_time = time.time()

    new_block = 'test block with transactions' + hash_result

    (hash_result, nonce) = proof_of_work(new_block, difficulty_bits)

    end_time = time.time()

    elapsed_time = end_time - start_time

    hash_power = float(int(nonce) / elapsed_time)

    return f"""
        Elapsed time: {elapsed_time} seconds.\n
        Hashing power: {hash_power} hashes per second.\n
        Nonce: {nonce}
        Hash: {hash_result}
    """


app.run(debug=True, port=5000)

# What is the parameters that you can modify to increase the speed of PoW function?
# Change hash function, introduce parallel computation
