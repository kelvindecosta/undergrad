from Individual import Individual
from typing import List, Tuple
import numpy as np
import string
import random


class Population:
    def __init__(
        self,
        test: str,
        alphabet: str,
        mutation_rate: float,
        individuals: List[Individual] = [],
    ):
        self.test = test
        self.alphabet = alphabet
        self.dna_length = len(test)
        self.mutation_rate = mutation_rate
        self.individuals = individuals

    def initialize(self, max_population):
        self.tot_fitness = 0
        self.max_fitness = 0
        self.max_ind = None
        while self.tot_fitness == 0:
            self.individuals = []
            for i in range(max_population):
                ind = Individual(self.test)
                ind.initialize(self.alphabet)
                ind.calc_fitness()
                self.tot_fitness += ind.fitness
                if ind.fitness > self.max_fitness:
                    self.max_fitness = ind.fitness
                    self.max_ind = ind
                self.individuals.append(ind)

    def calc_values(self):
        self.max_fitness = 0
        self.max_ind = None
        self.tot_fitness = 0
        for ind in self.individuals:
            ind.calc_fitness()
            self.tot_fitness += ind.fitness
            if ind.fitness > self.max_fitness:
                self.max_fitness = ind.fitness
                self.max_ind = ind

    # np.random.choice(
    #   ['pooh', 'rabbit', 'piglet', 'Christopher'],
    #   5,
    #   p=[0.5, 0.1, 0.1, 0.3]
    # )

    # def set_individuals(self, individuals):
    #     self.individuals = individuals

    def mutate(self, str: str) -> str:
        ret = ""
        for c in str:
            if random.random() <= self.mutation_rate:
                ret += random.choice(self.alphabet)
            else:
                ret += c
        return ret

    def crossover(
        self, ind1: Individual, ind2: Individual
    ) -> Tuple[Individual, Individual]:
        point = random.randint(1, self.dna_length - 1)
        str1 = self.mutate(ind1.dna[:point] + ind2.dna[point:])
        str2 = self.mutate(ind2.dna[:point] + ind1.dna[point:])
        ind3 = Individual(self.test, str1)
        ind4 = Individual(self.test, str2)
        return ind3, ind4

    def get_fittest(self):
        probability = []

        # print("Initial population: ")
        # [print(ind.dna, ind.fitness) for ind in self.individuals]
        if self.tot_fitness == 0:
            probability = [
                1 / len(self.individuals) for _ in range(len(self.individuals))
            ]
        else:
            probability = [ind.fitness / self.tot_fitness for ind in self.individuals]

        fittest_individuals = np.random.choice(
            self.individuals, len(self.individuals), p=probability
        )
        # print("\nProbability for the population: ", probability)
        # print("\nFittest Individuals:")
        # [print(r.dna) for r in fittest_individuals]
        return fittest_individuals

    def reproduce(self):
        fittest_individuals = self.get_fittest()
        new_individuals = []
        for i in range(0, len(fittest_individuals), 2):
            ind1, ind2 = self.crossover(
                fittest_individuals[i], fittest_individuals[i + 1]
            )
            new_individuals.append(ind1)
            new_individuals.append(ind2)
        new_Population = Population(
            self.test, self.alphabet, self.mutation_rate, new_individuals
        )

        # print("\nNew Populaition:")
        # [print(r.dna) for r in new_Population.individuals]
        return new_Population


if __name__ == "__main__":
    alphabet = string.digits + string.ascii_letters + string.punctuation + " "

    in1 = Individual("This is a string", "abcdefghijklmnop")
    in2 = Individual("This is a string", "1234567890123456")
    in3 = Individual("This is a string", "IIIIIIIIIIIIIIII")
    in4 = Individual("This is a string", "OOOOOOOOOOOOOOOO")
    in1.calc_fitness()
    in2.calc_fitness()
    in3.calc_fitness()
    in4.calc_fitness()
    inds = [in1, in2, in3, in4]

    pop = Population("This is a string", alphabet, 0.01, inds)
    # pop.calc_values()
    pop.initialize(20)
    pop.reproduce()
    # print(pop.max_population, pop.test, pop.alphabet, pop.dna_length)
    # print(len(pop.individuals))

    # in3, in4 = pop.crossover(pop.individuals[0], pop.individuals[1])
    # print(in3.dna)
    # print(in4.dna)
