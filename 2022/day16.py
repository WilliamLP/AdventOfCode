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
print(valves)

MAX_TIME = 30

def find_max_flow(valves, cur_valve_id, visited, time, flow_rate):
    max_flow = (MAX_TIME - time) * flow_rate
    cur_valve = valves[cur_valve_id]
    for adj_valve_id, dist in cur_valve['dists'].items():
        if adj_valve_id == cur_valve_id or adj_valve_id in visited:
            continue
        adj_flow = valves[adj_valve_id]['flow']
        time_inc = dist + 1
        if adj_flow == 0 or time + time_inc >= MAX_TIME:
            continue
        visited.add(adj_valve_id)
        max_flow = max(max_flow, flow_rate * time_inc + find_max_flow(
            valves, adj_valve_id, visited, time + time_inc, flow_rate + adj_flow))
        visited.remove(adj_valve_id)
    return max_flow


res = find_max_flow(valves, 'AA', set(), 0, 0)
print(res)