from collections import defaultdict

def decode_state(state):
    parts = state.split(' ')
    return [int(parts[0]), int(parts[1])], [int(parts[2]), int(parts[3])]  # pos, scores

def encode_state(pos, scores):
    return f'{pos[0]} {pos[1]} {scores[0]} {scores[1]}'

def main():
    pos = [int(str.strip()[-1]) for str in open('day21.txt')]
    universes = defaultdict(lambda: defaultdict(int))
    universes[0][encode_state(pos, [0, 0])] = 1

    turn_number = 0
    while turn_number in universes:
        active_player = turn_number  % 2
        states = universes[turn_number]
        for state, universe_count in states.items():
            state_pos, state_scores = decode_state(state)
            if state_scores[0] >= 21 or state_scores[1] >= 21:
                continue
            for roll1 in (1,2,3):
                for roll2 in (1,2,3):
                    for roll3 in (1,2,3):
                        roll = roll1 + roll2 + roll3
                        new_state_pos, new_state_scores = state_pos.copy(), state_scores.copy()
                        new_state_pos[active_player] = ((state_pos[active_player] + roll - 1) % 10) + 1
                        new_state_scores[active_player] += new_state_pos[active_player]
                        universes[turn_number + 1][encode_state(new_state_pos, new_state_scores)] += universe_count
        turn_number += 1
    # import pprint; pprint.pprint(universes)
    w1 = w2 = 0
    for rn, st in universes.items():
        for state, u_count in st.items():
            pos, scores = decode_state(state)
            if scores[0] >= 21:
                w1 += u_count
            if scores[1] >= 21:
                w2 += u_count
    print(f'{w1} {w2} Part 2 answer: {max(w1, w2)}')
main()