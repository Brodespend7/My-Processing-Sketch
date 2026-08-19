void setup() {
  size(800, 600);
  background(220, 245, 220);
  drawCow(width / 2, height / 2);
}

void drawCow(float x, float y) {

  fill(255);
  stroke(0);
  strokeWeight(3);
  ellipse(x, y + 50, 300, 200);

  fill(0);
  noStroke();
  ellipse(x - 60, y + 30, 70, 50);
  ellipse(x + 50, y + 70, 90, 60);
  ellipse(x + 20, y + 20, 50, 40);

  stroke(0);
  strokeWeight(3);
  fill(255);
  rect(x - 90, y + 120, 35, 70, 10);
  rect(x - 40, y + 120, 35, 70, 10);
  rect(x + 10, y + 120, 35, 70, 10);
  rect(x + 60, y + 120, 35, 70, 10);
 
  fill(0);
  rect(x - 90, y + 175, 35, 15, 5);
  rect(x - 40, y + 175, 35, 15, 5);
  rect(x + 10, y + 175, 35, 15, 5);
  rect(x + 60, y + 175, 35, 15, 5);

  fill(255);
  stroke(0);
  ellipse(x, y - 60, 180, 140);

  fill(255);
  ellipse(x - 85, y - 80, 50, 30);
  ellipse(x + 85, y - 80, 50, 30);

  fill(220);
  triangle(x - 50, y - 110, x - 70, y - 140, x - 30, y - 115);
  triangle(x + 50, y - 110, x + 70, y - 140, x + 30, y - 115);

  fill(255, 192, 203); // Pink
  stroke(0);
  ellipse(x, y - 30, 100, 60);

  fill(0);
  noStroke();
  ellipse(x - 20, y - 30, 12, 20);
  ellipse(x + 20, y - 30, 12, 20);

  fill(0);
  ellipse(x - 35, y - 75, 14, 14);
  ellipse(x + 35, y - 75, 14, 14);
}
