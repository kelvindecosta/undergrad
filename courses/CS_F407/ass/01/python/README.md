# Shakespeare Monkey genetic algorithm

The [infinite monkey theorem](https://en.wikipedia.org/wiki/Infinite_monkey_theorem) states: "a monkey hitting keys at random
on a typewriter keyboard for an infinite amount of time will almost surely type any given text, such as the complete works
of William Shakespeare." Unfortunately, the probability of this happening is miniscule.

So instead of randomly typing a string of characters, we propose using a Genetic Algorithm to find an unknown string.

## Problem

Given any target string, have a program find the correct string in a short amount of time.

## Settings

The Genetic Population takes in a few parameters:

- The _alphabet_ with which the DNA is encoded.
- The _Target String_ or the target DNA value which represents the optimal solution.
- The _Mutation Rate_ that determines the probability that a gene undergoes a mutation.
- The _Population Size_ taken in each generation.
- And the _Fitness Function_ which represents how fitness of an individual is measured.

## Method

Our approach is based on Genetic Algorithms.

1. The strings are first **initialized** to a random value.
2. Then the strings with greatest **fitness** are selected into a mating pool.
3. **Reproduction** then occurs a number of times to produce a new population, where:
   - 2 Parents are picked with probability relative to their fitness function.
   - _Crossover_ mixes and matches the genes to create children.
   - _Mutation_ helps increase the diversity of the Population.
   - The new child is added to the population of the next Generation.
4. The old population is replaced with the new and step 2 repeated until 100% fitness is achieved.

## Implementation

The code was implemented in [Python](https://www.python.org/).
