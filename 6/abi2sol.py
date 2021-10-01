import json


def handle_function(identifier):
    name = identifier["name"]

    inputs = [f"{input['type']} {input['name']}" for input in identifier["inputs"]]
    arguments = ", ".join(inputs)

    modifiers = []

    mutability = identifier["stateMutability"]

    modifiers.append("external")

    if mutability == "view" or mutability == "payable":
        modifiers.append(mutability)

    modifiers_str = " ".join(modifiers) if len(modifiers) > 0 else ""

    return_args = [f" {output['type']} {output['name']}" for output in identifier["outputs"]]

    if len(return_args) > 0:
        returns = f" returns ({', '.join(return_args)})"
    else:
        returns = ""

    return f"function {name} ({arguments}) {modifiers_str}{returns}"


def handle_event(identifier):
    return f"event {identifier['name']} ()"


def handle_abi(abi):
    entities = []

    for identifier in abi:
        type = identifier["type"]

        if type == "function":
            entities.append(handle_function(identifier))
        elif type == "event":
            entities.append(handle_event(identifier))

    start = "interface Abi2Sol {\n\t"
    return start + ";\n\t".join(entities) + ";\n}"


with open("abi.json") as fin:
    abi = json.loads(fin.read())

with open("output.sol", "w+") as fout:
    fout.write(handle_abi(abi))
