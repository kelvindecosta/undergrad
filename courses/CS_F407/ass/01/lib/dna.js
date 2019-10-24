function DNA(genes) {
  this.mutationRate = 0.01;

  // Genes represent the direction to travel at each frame
  if (genes) this.genes = genes;
  else {
    this.genes = [];
    for (var i = 0; i < lifespan; i++) {
      this.genes[i] = p5.Vector.random2D();
      this.genes[i].setMag(0.1);
    }
  }

  // Cross over of genes between two individuals
  this.crossover = function (partner) {
    var newDNA = [];
    var mid = Math.floor(random(this.genes.length));
    for (var i = 0; i < this.genes.length; i++) {
      newDNA[i] = i > mid ? this.genes[i] : partner.genes[i];
    }
    return new DNA(newDNA);
  };

  // Mutation randomizes a random gene
  this.mutation = function () {
    for (var i = 0; i < this.genes.length; i++) {
      if (random(1) < this.mutationRate) {
        this.genes[i] = p5.Vector.random2D();
        this.genes[i].setMag(0.1);
      }
    }
  };
}
