import string
import time
from Population import Population


def Start():
    population = Population(target_string, alphabet, mutation_rate)
    population.initialize(max_population)
    fittest_individual = population.max_ind
    max_fitness = population.max_fitness
    print("Fittest individual:", fittest_individual.dna)
    print("With a fitness score of: ", max_fitness)
    new_population = population.reproduce()
    return new_population


def NextGeneration(new_population):
    population = new_population
    population.calc_values()
    fittest_individual = population.max_ind
    max_fitness = population.max_fitness
    print("Fittest individual     :", fittest_individual.dna)
    print("With a fitness score of:", max_fitness)
    new_population = population.reproduce()
    if max_fitness == 1:
        return new_population, True
    return new_population, False


if __name__ == "__main__":
    # alphabet = string.digits + string.ascii_letters + string.punctuation + " "
    # alphabet = string.ascii_letters + " "
    alphabet = string.ascii_lowercase + " "
    target_string = "to be or not to be that is the question"
    mutation_rate = 0.01
    max_population = 100

    new_population = Start()
    total_generations = 1
    found = False

    while not found:
        new_population, found = NextGeneration(new_population)
        print("Generation:             ", total_generations)
        if found:
            print(
                "Found the fittest individual possible in",
                total_generations,
                "generations",
            )
        total_generations += 1
        time.sleep(0.01)
