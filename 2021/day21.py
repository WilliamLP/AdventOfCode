

def roll(die):
    die['val'] += 1
    return ((die['val'] - 1 ) % 100) + 1

def main():
    players = []
    die = {'val': 0}
    for str in open('day21.txt'):
        pos = int(str.strip()[-1])
        players.append({
            'pos': pos,
            'score': 0
        })

    player_num = 0
    while True:
        player = players[player_num]
        player['pos'] = ((player['pos'] + roll(die) + roll(die) + roll(die) - 1) % 10) + 1
        player['score'] += player['pos']

        player_num = 1-player_num
        if player['score'] >= 1000:
            other_player = players[player_num]
            break
    print(f"Part 1 answer {other_player['score']} * {die['val']} = {other_player['score'] * die['val']}")

main()