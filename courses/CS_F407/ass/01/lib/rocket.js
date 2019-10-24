function Rocket(dna) {
  this.pos = createVector(width / 2, height);
  this.vel = createVector();
  this.acc = createVector();
  this.crashed = false;
  this.completed = false;

  if (dna) this.dna = dna;
  else this.dna = new DNA();

  this.distance = 0;

  this.applyForce = function (force) {
    this.acc.add(force);
  };

  this.calculateDistance = function () {
    this.distance = dist(this.pos.x, this.pos.y, target.x, target.y);
  };

  this.check = function () {
    // Check if out of bounds
    if (
      this.pos.x < 0 ||
      this.pos.x > width ||
      this.pos.y < 0 ||
      this.pos.y > height
    ) {
      this.crashed = true;
      return;
    }

    // Check if on target
    if (dist(this.pos.x, this.pos.y, target.x, target.y) < 20) {
      this.completed = true;
      return;
    }

    // Check if colliding
    for (var i = 0; i < obstacles.length; i++) {
      if (obstacles[i].collides(this.pos)) {
        this.crashed = true;
      }
    }
  };

  this.update = function () {
    this.check();

    // Update position if still moving
    if (!this.completed && !this.crashed) {
      this.applyForce(this.dna.genes[counter]);
      this.vel.add(this.acc);
      this.pos.add(this.vel);
      this.acc.mult(0);
    }

    // Slow rocket
    if (counter > lifespan) {
      this.vel.mult(0.9);
      this.calculateDistance();
    }
  };

  this.show = function () {
    push();
    translate(this.pos.x, this.pos.y);
    rotate(this.vel.heading() + PI / 2);
    this.drawRocket(1);
    pop();
  };

  this.drawRocket = function (s) {
    noStroke();
    fill(200, 175);
    if (this.completed) {
      fill(0, 255, 0, 175);
    }

    if (this.crashed) {
      fill(255, 0, 0, 175);
    }

    // Body
    rect(0, 0, 4 * s, 4 * s);
    rect(-s, 4 * s, 6 * s, 14 * s);
    rect(-2 * s, 12 * s, 1 * s, 2 * s);
    rect(5 * s, 12 * s, 1 * s, 2 * s);
    rect(-4 * s, 12 * s, 2 * s, 8 * s);
    rect(6 * s, 12 * s, 2 * s, 8 * s);

    fill(51, 175);
    rect(0, 8 * s, 4 * s, 4 * s);

    if (counter < lifespan && !(this.completed || this.crashed)) {
      // black window
      fill(22, 122, 198, 175);
      rect(0, 8 * s, 4 * s, 4 * s);

      // flames
      fill(255, 165, 0, 175);
      rect(0, 18 * s, 2 * s, 4 * s);
      rect(2 * s, 18 * s, 2 * s, 6 * s);
    }
  };
}
