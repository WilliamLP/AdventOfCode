input = [l.strip() for l in open('day17.txt').readlines()]
a = int(input[0].split(' ')[-1])
b = int(input[1].split(' ')[-1])
c = int(input[2].split(' ')[-1])

ops = ['adv', 'bxl', 'bst', 'jnz', 'bxc', 'out', 'bdv', 'cdv']

program = [int(ch) for ch in input[4].split(' ')[-1].split(',')]
def run(program, a, b, c):
    out = []

    i_ptr = 0
    while True:
        if i_ptr >= len(program):
            break
        oc, op_lit = program[i_ptr], program[i_ptr + 1]
        if op_lit <= 3:
            op_combo = op_lit
        elif op_lit == 4:
            op_combo = a
        elif op_lit == 5:
            op_combo = b
        elif op_lit == 6:
            op_combo = c
        else:
            op_combo = None

        # print(f"({a:b},{b:b},{c:b})", f"i:{i_ptr}", ops[oc], f"{op_lit}|{op_combo:b}")

        if oc == 0:  # adv
            a = a // (2 ** op_combo)
        elif oc == 1:  # bxl
            b = b ^ op_lit
        elif oc == 2:  # bst
            b = op_combo % 8
        elif oc == 3:  # jnz
            if a > 0:
                i_ptr = op_lit - 2
        elif oc == 4:  # bxc
            b = b ^ c
        elif oc == 5:  # out
            out.append(op_combo % 8)
            # print(f'OUTPUT: {op_combo%8:b}')
        elif oc == 6:  # bdv
            b = a // (2 ** op_combo)
        elif oc == 7:  # cdv
            c = a // (2 ** op_combo)

        # print(oc, op_lit, op_combo, a, b, c)

        i_ptr += 2

    return out

part1_out = run(program, a, b, c)
print('Part 1:', ','.join(str(n) for n in part1_out))
def find(i, n):
    found = []
    for j in range(0, 8):
        val = n * 8 + j
        out = run(program, val, b, c)
        if out[-i:] != program[-i:]:
            continue
        if i == len(program):
            found.append(val)
        else:
            found.extend(find(i + 1, val))
        # print(f"{i:b}", f"{j:b}", ','.join(str(o) for o in out))
    return found

res = find(1, 0)
# print('Find: ', ','.join([f'{x:b} ({x})' for x in res]))
print('Part 2: ', min(res))

#
# print(f"{202366627359274:b}")

