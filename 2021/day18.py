
class Snailfish:
    @classmethod
    def parse(cls, str):
        substr = str[1:]  # Pop [
        left, substr = Snailfish.parse_to_char(substr, ',')
        right, substr = Snailfish.parse_to_char(substr, ']')
        return Snailfish(False, left, right), substr[1:]

    @classmethod
    def parse_to_char(cls, str, ch):
        if not str.startswith('['):
            sep_index = str.find(ch)
            return Snailfish(True, int(str[0:sep_index])), str[sep_index + 1:]
        return Snailfish.parse(str)

    def __init__(self, is_number, left, right=None):
        self.is_number = is_number
        if is_number:
            self.number = left
        else:
            self.left = left
            self.right = right

    def __str__(self):
        if self.is_number:
            return f'{self.number}'
        else:
            return f'[{self.left},{self.right}]'

    def add(self, fish):
        res = Snailfish(False, self, fish)

        while True:
            while res.explode():
                pass
            if not res.reduce():  # Done when no reduction
                break
        return res

    def all_numbers(self):
        res = []
        if self.left.is_number:
            res.append(self.left)
        else:
            res.extend(self.left.all_numbers())

        if self.right.is_number:
            res.append(self.right)
        else:
            res.extend(self.right.all_numbers())

        return res

    def find_explode(self, level=0):
        # Search for an exploding node, which will always be a pair of two numbers
        if level >= 4:
            return self

        if not self.left.is_number:
            exploded_left = self.left.find_explode(level + 1)
            if exploded_left:
                return exploded_left
        if not self.right.is_number:
            exploded_right = self.right.find_explode(level + 1)
            if exploded_right:
                return exploded_right
        return None

    def explode(self):
        explode_node = self.find_explode(0)
        if explode_node:
            all_nums = self.all_numbers()
            left_index = all_nums.index(explode_node.left)
            if left_index > 0:
                all_nums[left_index - 1].number += explode_node.left.number
            if left_index + 2 < len(all_nums):
                all_nums[left_index + 2].number += explode_node.right.number
            explode_node.is_number = True
            explode_node.number = 0
            return True
        else:
            return False

    def find_reduce(self):
        # Search for an reducing node, which is a number > 9
        if self.is_number:
            if self.number > 9:
                return self
            else:
                return None

        reduced_left = self.left.find_reduce()
        if reduced_left:
            return reduced_left
        reduced_right = self.right.find_reduce()
        if reduced_right:
            return reduced_right
        return None

    def reduce(self):
        reduce_node = self.find_reduce()
        if reduce_node:
            reduce_node.is_number = False
            reduce_node.left = Snailfish(True, reduce_node.number // 2)
            reduce_node.right = Snailfish(True, (reduce_node.number + 1) // 2)
            return True
        else:
            return False

    def magnitude(self):
        if self.is_number:
            return self.number
        else:
            return self.left.magnitude() * 3 + self.right.magnitude() * 2

def part_1():
    fish_strs = [str.strip() for str in open('day18_test.txt')]
    fishes = [Snailfish.parse(fish_str)[0] for fish_str in fish_strs]

    sum = None
    for fish in fishes:
        if sum:
            sum = sum.add(fish)
        else:
            sum = fish
    print(f'Magnitude: {sum.magnitude()}')

def part_2():
    fish_strs = [str.strip() for str in open('day18.txt')]
    max_magnitude = 0
    for i in range(len(fish_strs)):
        for j in range(len(fish_strs)):
            if i == j:
                continue
            max_magnitude = max(Snailfish.parse(fish_strs[i])[0].add(
                Snailfish.parse(fish_strs[j])[0]).magnitude(), max_magnitude)
    print(f'Max magnitude for pairwise sum: {max_magnitude}')

part_1()
part_2()