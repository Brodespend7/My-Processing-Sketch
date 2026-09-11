// brodden spendlove | 9/11/26 | CarRunner
Car DraycenMaidCostumePEAKKK,DraycenMaidCostumePEAKKK2,DraycenMaidCostumePEAKKK3,DraycenMaidCostumePEAKKK4,DraycenMaidCostumePEAKKK5,DraycenMaidCostumePEAKKK6;

void setup() {
  size(200,200);
  DraycenMaidCostumePEAKKK = new Car();
  DraycenMaidCostumePEAKKK2 = new Car();
  DraycenMaidCostumePEAKKK3 = new Car();
  DraycenMaidCostumePEAKKK4 = new Car();
  DraycenMaidCostumePEAKKK5 = new Car();
  DraycenMaidCostumePEAKKK6 = new Car();
  
}

void draw() {
  background(255);
  DraycenMaidCostumePEAKKK.display();
  DraycenMaidCostumePEAKKK.move();
  DraycenMaidCostumePEAKKK2.display();
  DraycenMaidCostumePEAKKK2.move();
  DraycenMaidCostumePEAKKK3.display();
  DraycenMaidCostumePEAKKK3.move();
  DraycenMaidCostumePEAKKK4.display();
  DraycenMaidCostumePEAKKK4.move();
  DraycenMaidCostumePEAKKK5.display();
  DraycenMaidCostumePEAKKK5.move();
  DraycenMaidCostumePEAKKK6.display();
  DraycenMaidCostumePEAKKK6.move();
}
