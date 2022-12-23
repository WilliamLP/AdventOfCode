def monkey_val(monkey_id):
    if monkey_id == 'humn':
        return 'humn'
    mstr = monkeys[monkey_id]
    if mstr.isnumeric():
        return int(mstr)
    m1, op, m2 = mstr.split(' ')
    v1, v2 = monkey_val(m1), monkey_val(m2)
    if v1 == 'humn' or v2 == 'humn':
        return 'humn'

    if op == '+':
        return v1 + v2
    if op == '-':
        return v1 - v2
    if op == '*':
        return v1 * v2
    if op == '/':
        return v1 // v2


def find_humn_val(monkey_id, val_needed):
    if monkey_id == 'humn':
        return val_needed
    mstr = monkeys[monkey_id]
    m1, op, m2 = mstr.split(' ')
    v1, v2 = monkey_val(m1), monkey_val(m2)
    if v1 == 'humn':
        if monkey_id == 'root':
            return find_humn_val(m1, v2)
        if op == '+':
            return find_humn_val(m1, val_needed - v2)
        if op == '-':
            return find_humn_val(m1, val_needed + v2)
        if op == '*':
            return find_humn_val(m1, val_needed // v2)
        if op == '/':
            return find_humn_val(m1, val_needed * v2)
    elif v2 == 'humn':
        if monkey_id == 'root':
            return find_humn_val(m2, v1)
        if op == '+':
            return find_humn_val(m2, val_needed - v1)
        if op == '-':
            return find_humn_val(m2, -(val_needed - v1))
        if op == '*':
            return find_humn_val(m2, val_needed // v1)
        if op == '/':
            return find_humn_val(m2, v1 // val_needed)

monkeys = {}
for str in open('day21.txt'):
    strs = str.strip().split(' ')
    monkeys[str[0:4]] = str.strip()[6:]

print('Part 2', find_humn_val('root', 0))