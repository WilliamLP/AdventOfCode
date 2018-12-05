
with open("day1.txt") as f:
    l = [int(line) for line in f]

print('List total is ' + str(sum(l)))

current_total = 0
seen = set()

i = 0
loops = 0
while True:
    if i == 0:
        loops += 1
    current_total += l[i]

    if current_total in seen:
        print('Found {} {} {}'.format(current_total, loops, i))
        break
    seen.add(current_total)

    i = (i + 1) % len(l)
