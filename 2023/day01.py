import re

nums = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
total = 0
for st_orig in open('day01.txt'):
    st_orig = st_orig.strip()
    st = st_orig
    i = 0
    while i < len(st):
        for j, n_str in enumerate(nums):
            if st[i:].startswith(n_str):
                st = st[:i] + str(j + 1) + st[i + len(n_str):]
                break
        i += 1
    st = re.sub('[a-z]', '', st)
    total += int(st[0] + st[-1])
    print(st, st_orig)

print(total)