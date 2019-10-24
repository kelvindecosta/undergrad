function Population() {
  this.rockets = [];
  this.populationSize = 50;
  this.matingPool = [];

  // Create rockets
  for (var i = 0; i < this.populationSize; i++) {
    this.rockets[i] = new Rocket();
  }

  // Define run
  this.run = function () {
    this.rockets.forEach(function (rocket) {
      rocket.update();
      rocket.show();
    });
  };

  // Define fitness function and create mating pool based on distance to target
  this.evaluate = function () {
    // Distance between each rocket and target
    var distances = [];
    this.rockets.forEach(function (rocket) {
      distances.push(rocket.distance);
    });

    // find the max and min distances
    var max = Math.max.apply(null, distances);
    var min = Math.min.apply(null, distances);

    // loop through each distance
    for (var i = 0; i < distances.length; i++) {
      // map between 100 and 0
      distances[i] = map(distances[i], min, max, 1, 0);
      distances[i] = 100 * distances[i] ** 4;
      distances[i] = Math.floor(distances[i]);

      // Encourage good and discourage poor behaviour
      if (this.rockets[i].completed) distances[i] *= 10;
      if (this.rockets[i].crashed) distances[i] *= 0.01;

      // Create mating pool
      // Probability of being picked is inversely proportional to distance
      for (var j = 0; j < distances[i]; j++) {
        this.matingPool.push(this.rockets[i]);
      }
    }
  };

  // Perform 'natural' selection
  this.selection = function () {
    var newRockets = [];

    // Create all new rockets from 2 parents
    for (var i = 0; i < this.rockets.length; i++) {
      var parentA = random(this.matingPool).dna;
      var parentB = random(this.matingPool).dna;
      var child = parentA.crossover(parentB);
      child.mutation();
      newRockets[i] = new Rocket(child);
    }
    this.rockets = newRockets;
  };
}
