var population;
var counter = 0;
var lifespan = 600;
var target;
var obstacles = new Array(2);

function setup() {
  var canvas = createCanvas(windowWidth, windowHeight);
  canvas.parent("sketch-holder");
  target = createVector(width / 2, height / 4);
  obstacles[0] = new Obstacle(width / 2, height / 2, width / 2, 50);
  obstacles[1] = new Obstacle(0, (3 * height) / 4, width / 2, 50);
  population = new Population();
}

function draw() {
  background(51);
  drawTarget(2);

  for (var i = 0; i < obstacles.length; i++) {
    obstacles[i].draw();
  }
  population.run();
  counter++;

  if (counter > lifespan + 50) {
    population.evaluate();
    population.selection();
    counter = 0;
  }
}

function drawTarget(s) {
  noStroke();
  fill(255);
  ellipse(target.x, target.y, 20 * s, 20 * s);
  fill(255, 0, 0);
  ellipse(target.x, target.y, 16 * s, 16 * s);
  fill(255);
  ellipse(target.x, target.y, 12 * s, 12 * s);
  fill(255, 0, 0);
  ellipse(target.x, target.y, 8 * s, 8 * s);
  fill(255);
  ellipse(target.x, target.y, 4 * s, 4 * s);
}
