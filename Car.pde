class Car {
  // Member Variables: the data for a car
  color c;
  float x, y, speed;

  // Constructor: Assign all member variables
  Car() {
    c = color(random(255), random(255), random(255));
    x = random(width);
    y = random(height);
    speed = random(1, 10);
  }

  // Member Methods: behaviors of the car
  void move() {
    x = x + speed;
    if (x > width) {
      x = 0;
    }else if (x< 0){ 
      x = width;
    }
  }

  void display() {
    fill(0);
    rect(x+3,y-2,7,14);
    fill(c);
    rect(x, y, 30, 10);
  }
}
