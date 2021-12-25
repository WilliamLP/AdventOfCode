REGS = {'w': 0, 'x': 1, 'y': 2, 'z': 3}

def execute(line, regs, input_arr):
    instr, reg, operand = line
    if instr == 'inp':
        regs[REGS[reg]] = int(input_arr.pop(0))
    else:
        if operand in REGS.keys():
            n = regs[REGS[operand]]
        else:
            n = int(operand)
        if instr == 'add':
            regs[REGS[reg]] += n
        elif instr == 'mul':
            regs[REGS[reg]] *= n
        elif instr == 'mod':
            regs[REGS[reg]] %= n
        elif instr == 'div':
            regs[REGS[reg]] //= n
        elif instr == 'eql':
            regs[REGS[reg]] = 1 if regs[REGS[reg]] == n else 0

MEMO2 = {}
def execute_all(chunks, pos, input, z):
    key = f'{pos} {input} {z}'
    if key in MEMO2:
        return MEMO2[key]
    regs = [0, 0, 0, z]
    input_arr = list(str(input))
    for line in chunks[pos]:
        execute(line, regs, input_arr)
    res = regs[REGS['z']]
    MEMO2[key] = res
    return res

MEMO = {}
MIN_Z = 999999
def find(chunks, pos, z):
    global MIN_Z

    key = f'{pos} {z}'
    if key in MEMO:
        return MEMO[key]
    found = None

    # PART 1
    # for i in (9,8,7,6,5,4,3,2,1):
    # PART 2
    for i in (1,2,3,4,5,6,7,8,9):
        exec_result = execute_all(chunks, pos, i, z)
        if(pos == 13):
            if abs(exec_result) < MIN_Z:
                print(f'Min z {exec_result}')
                MIN_Z = abs(exec_result)
            if exec_result == 0:
                print('FOUND 0')
                found = [i]
                break
            else:
                found = None
        else:
            new_found = find(chunks, pos + 1, exec_result)
            if new_found:
                print('NEW FOUND')
                found = [i] + new_found
                break

    MEMO[key] = found
    return found

def main():
    code = []
    for line in open('day24.txt'):
        tokens = line.strip().split(' ')
        code.append((tokens[0], tokens[1], tokens[2] if len(tokens) > 2 else None))

    chunks = []
    rest = code
    while rest:
        chunks.append(rest[0:18])
        rest = rest[18:]

    res = find(chunks, 0, 0)
    print(f"Part 2 Answer: {''.join([str(ch) for ch in res])}")

main()