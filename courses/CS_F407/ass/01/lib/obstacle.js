function Obstacle(x, y, w, h) {
  this.x1 = x;
  this.y1 = y;
  this.x2 = x + w;
  this.y2 = y + h;

  this.draw = function () {
    noStroke();
    fill(0);
    rect(this.x1, this.y1, this.x2 - this.x1, this.y2 - this.y1);
  };

  this.collides = function (other) {
    return (
      other.x > this.x1 &&
      other.x < this.x2 &&
      other.y > this.y1 &&
      other.y < this.y2
    );
  };
}
