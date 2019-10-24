import string
import random

# print(string.printable)
# print(string.printable.replace('\n', ''))


class Individual:
    def __init__(self, test: str, dna: str = ""):
        self.test = test
        self.dna = dna

    def initialize(self, alphabet: str):
        self.dna = "".join(random.choice(alphabet) for _ in range(len(self.test)))

    # def set_dna(self, dna: str):
    #     self.dna = dna

    def calc_fitness(self):
        correct = 0
        for i in range(len(self.test)):
            if self.dna[i] == self.test[i]:
                correct += 1
        self.fitness = correct / len(self.test)
        self.fitness = self.fitness ** 4


if __name__ == "__main__":
    alphabet = string.digits + string.ascii_letters + string.punctuation + " "
    ind = Individual("lol waaatt")
    ind.initialize(alphabet)
    ind.calc_fitness()
    print(ind.dna, ind.fitness)
    ind = Individual("lol waaatt", "lol biiits")
    # ind.set_dna()
    ind.calc_fitness()
    print(ind.dna, ind.fitness)
