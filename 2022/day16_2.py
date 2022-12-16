valves = {}
for str in open('day16.txt'):
    strs = str.strip().split(' ')
    rate = int(strs[4].replace('rate=', '').replace(';', ''))
    adj_string = str.strip().split('valve')[1].replace('s', '')[1:]
    valves[strs[1]] = {'flow': rate, 'adj': adj_string.split(', ')}


def find_dists(valves, valve_id):
    base_valve = valves[valve_id]
    base_valve['dists'] = {valve_id: 0}
    next_list = base_valve['adj']
    dist = 0
    while next_list:
        lst = next_list
        next_list = []
        dist += 1
        for cur_valve_id in lst:
            if cur_valve_id in base_valve['dists']:
                continue
            base_valve['dists'][cur_valve_id] = dist
            next_list.extend(valves[cur_valve_id]['adj'])

for valve_id in valves.keys():
    find_dists(valves, valve_id)

MAX_TIME = 26

# Clock1 = time until human move, Clock2 = time until elephant move
def find_max_flow(valves, cur_valve_id1, clock1, cur_valve_id2, clock2, visited, time, flow_rate):
    # advance time until human or elephant has move available
    if time == MAX_TIME:
        return 0
    if clock1 > 0 and clock2 > 0:
        time_inc = min(clock1, clock2)
        new_flow_rate = flow_rate
        if clock1 == time_inc:
            new_flow_rate += valves[cur_valve_id1]['flow']
        if clock2 == time_inc:
            new_flow_rate += valves[cur_valve_id2]['flow']

        # print('flow', time, time + time_inc, flow_rate * time_inc)
        return flow_rate * time_inc + find_max_flow(valves, cur_valve_id1, clock1 - time_inc,
            cur_valve_id2, clock2 - time_inc, visited, time + time_inc, new_flow_rate)

    if clock1 == 0:
        mover, cur_valve_id = 1, cur_valve_id1
    else:
        mover, cur_valve_id = 2, cur_valve_id2

    cur_valve = valves[cur_valve_id]
    max_flow = 0

    for adj_valve_id, dist in cur_valve['dists'].items():
        if adj_valve_id == cur_valve_id or adj_valve_id in visited:
            continue
        adj_flow = valves[adj_valve_id]['flow']
        time_inc = dist + 1
        if adj_flow == 0 or time + time_inc >= MAX_TIME:
            continue
        visited.add(adj_valve_id)
        max_flow = max(max_flow, find_max_flow(
            valves,
            adj_valve_id if mover == 1 else cur_valve_id1,
            time_inc if mover == 1 else clock1,
            adj_valve_id if mover == 2 else cur_valve_id2,
            time_inc if mover == 2 else clock2,
            visited,
            time,
            flow_rate))
        visited.remove(adj_valve_id)

    # if we fall out of this loop, we are waiting until the end
    time_inc = MAX_TIME - time
    max_flow = max(max_flow, find_max_flow(
        valves,
        adj_valve_id if mover == 1 else cur_valve_id1,
        time_inc if mover == 1 else clock1,
        adj_valve_id if mover == 2 else cur_valve_id2,
        time_inc if mover == 2 else clock2,
        visited,
        time,
        flow_rate))

    return max_flow

res = find_max_flow(valves, 'AA', 0, 'AA', 0, set(['AA']), 0, 0)
print(res)