

def new_tree():
    return {'left': None, 'left_count': 0,
            'right': None, 'right_count': 0}

def add_to_tree(branch, str):
    if str == '':
        return
    if str.startswith('0'):
        if not branch['left']:
            branch['left'] = new_tree()
        add_to_tree(branch['left'], str[1:])
        branch['left_count'] += 1;
    else:
        if not branch['right']:
            branch['right'] = new_tree()
        add_to_tree(branch['right'], str[1:])
        branch['right_count'] += 1;

def traverse_tree(tree, use_most_common):
    if tree['left_count'] + tree['right_count'] == 0:
        return ''

    if not tree['right']:
        dir = 'left'
    elif not tree['left']:
        dir = 'right'
    elif use_most_common:
        if tree['right_count'] >= tree['left_count']:
            dir = 'right'
        else:
            dir = 'left'
    else:
        if (tree['right_count'] < tree['left_count']):
            dir = 'right'
        else:
            dir = 'left'

    return ('1' if dir == 'right' else '0') + traverse_tree(tree[dir], use_most_common)

tree = new_tree()
for str in open('day3.txt'):
    add_to_tree(tree, str.strip())

print(int(traverse_tree(tree, True), 2))
print(int(traverse_tree(tree, False), 2))

