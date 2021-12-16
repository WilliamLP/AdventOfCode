class bit_popper:
    def __init__(self, hex):
        self.str = ''
        for ch in hex:
            self.str += str(bin(int(ch, 16))[2:]).zfill(4)

    def pop(self, n_bits):
        res = int(self.str[0:n_bits], 2)
        self.str = self.str[n_bits:]
        return res

    def done(self):
        return '1' not in self.str

def read_packet(bp):
    version = bp.pop(3)
    type_id = bp.pop(3)
    length = 6
    val = 0
    sub_packets = []

    if type_id == 4:
        # literal value
        val = 0
        while True:
            first_bit = bp.pop(1)
            val = (val << 4) + bp.pop(4)
            length += 5
            if not first_bit:
                break
    else:
        # operator
        length_type_id = bp.pop(1)
        length += 1
        if not length_type_id:
            # 15 bits are the number bits of the sub-packets contained by this packet.
            num_subpacket_bits = bp.pop(15)
            length += 15
            sub_length = 0
            while sub_length < num_subpacket_bits:
                sub_packet = read_packet(bp)
                length += sub_packet['length']
                sub_length += sub_packet['length']
                sub_packets.append(sub_packet)
        else:
            # 11 bits are a number that represents the number of sub-packets immediately contained
            num_sub_packets = bp.pop(11)
            length += 11
            for i in range(num_sub_packets):
                sub_packet = read_packet(bp)
                length += sub_packet['length']
                sub_packets.append(sub_packet)

    return {
        'version': version,
        'type_id': type_id,
        'val': val,
        'length': length,
        'sub_packets': sub_packets
    }

def version_sum(packet):
    return packet['version'] + sum([version_sum(sub) for sub in packet['sub_packets']])

def evaluate(packet):
    type_id = packet['type_id']
    sub_vals = [evaluate(sub_packet) for sub_packet in packet['sub_packets']]

    if type_id == 0: # sum
        return sum(sub_vals)
    elif type_id == 1: # product
        product = 1
        for val in sub_vals:
            product *= val
        return product
    elif type_id == 2: # min
        return min(sub_vals)
    elif type_id == 3: # max
        return max(sub_vals)
    elif type_id == 4: # literal
        return packet['val']
    elif type_id == 5: # gt
        return 1 if sub_vals[0] > sub_vals[1] else 0
    elif type_id == 6: # lt
        return 1 if sub_vals[0] < sub_vals[1] else 0
    elif type_id == 7: # eq
        return 1 if sub_vals[0] == sub_vals[1] else 0

    raise Exception(f'Unknown type {packet}')

def main():
    hex = open('day16.txt').readline()
    bp = bit_popper(hex)
    packet = read_packet(bp)
    print(version_sum(packet))  # part 1
    print(evaluate(packet))  # part 2


main()

