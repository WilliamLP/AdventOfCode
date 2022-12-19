

memo = {}
def max_geodes(time, inventory, bots):
    global cost_ore, cost_clay, cost_obsidian

    if time == 0:
        return 0

    memo_key = tuple([time] + inventory + bots)
    # print(memo_key)
    if memo_key in memo:
        return memo[memo_key]

    # check if this position is dominated by another one
    #for prev_memo_key in memo:
    #    if all(memo_key[i] <= prev_memo_key[i] for i in range(8)):
    #        print('Total domination')
    #        memo[memo_key] = 0
    #        return 0

    next_inventory = inventory.copy()
    next_inventory[0] += bots[0]
    next_inventory[1] += bots[1]
    next_inventory[2] += bots[2]

    res = 0
    # Buy geode bot (always)
    if inventory[0] >= cost_ore[3] and inventory[2] >= cost_obsidian:
        next_inventory[0] -= cost_ore[3]
        next_inventory[2] -= cost_obsidian
        bots[3] += 1
        res = max(res, bots[3] - 1 + max_geodes(time - 1, next_inventory, bots))
        next_inventory[0] += cost_ore[3]
        next_inventory[2] += cost_obsidian
        bots[3] -= 1
    elif inventory[0] >= cost_ore[2] and inventory[1] >= cost_clay:
        # Buy obsidian bot (always)
        next_inventory[0] -= cost_ore[2]
        next_inventory[1] -= cost_clay
        bots[2] += 1
        res = max(res, bots[3] + max_geodes(time - 1, next_inventory, bots))
        next_inventory[0] += cost_ore[2]
        next_inventory[1] += cost_clay
        bots[2] -= 1
    else:
        # Do nothing
        res = bots[3] + max_geodes(time - 1, next_inventory, bots)

        # Buy ore bot -- Skip if it can't pay for itself
        if inventory[0] >= cost_ore[0] and time > cost_ore[0]:
            next_inventory[0] -= cost_ore[0]
            bots[0] += 1
            res = max(res, bots[3] + max_geodes(time - 1, next_inventory, bots))
            next_inventory[0] += cost_ore[0]
            bots[0] -= 1

        # Buy clay bot
        if inventory[0] >= cost_ore[1]:
            next_inventory[0] -= cost_ore[1]
            bots[1] += 1
            res = max(res, bots[3] + max_geodes(time - 1, next_inventory, bots))
            next_inventory[0] += cost_ore[1]
            bots[1] -= 1

    memo[memo_key] = res
    return res

part = 2
T = 24 if part == 1 else 32
part1 = 0
# Part 1: real	23m13.059s
product = 1
for i, line in enumerate(open('day19.txt')):
    memo = {}
    ints = [int(s) for s in line.split(' ') if s.isdecimal()]
    print(line.strip())
    cost_ore = ints[0:3] + [ints[4]]
    cost_clay = ints[3]
    cost_obsidian = ints[5]


    max_g = max_geodes(T, [0, 0, 0], [1, 0, 0, 0])
    print(f'Blueprint {i + 1} Geodes {max_g}')
    part1 += (i + 1) * max_g
    if part == 2:
        product *= max_g
        print(f'Product now {product}\n')
        if i == 2:
            break
print('Part 1', part1)
