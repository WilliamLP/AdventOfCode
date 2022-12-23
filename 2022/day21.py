monkeys = {}
for str in open('day21.txt'):
    strs = str.strip().split(' ')
    monkeys[str[0:4]] = str.strip()[6:]

def monkey_val(monkey_id):
    mstr = monkeys[monkey_id]
    if mstr.isnumeric():
        return int(mstr)

    m1, op, m2 = mstr.split(' ')
    v1, v2 = monkey_val(m1), monkey_val(m2)
    if op == '+':
        return v1 + v2
    if op == '-':
        return v1 - v2
    if op == '*':
        return v1 * v2
    if op == '/':
        return v1 // v2
    print('UNKNOWN OP ' + op)

print('Part 1', monkey_val('root'))