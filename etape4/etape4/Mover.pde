class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
  float velocityY = 0.01;
  
  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0.5, velocityY);
    gravity = new PVector(0, velocityY);
  } 
  void update() {
    velocity.add(gravity);
    location.add(velocity);
  }  

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 48, 48);
  }

  void checkEdges() {
    if (location.x + 24 > width) {
      velocity.x = -velocity.x;
      location.x = width - 24;
    }
    else if (location.x  - 24 < 0) {
      velocity.x = -velocity.x;
      location.x = 24;
    }
    if (location.y  + 24 > height) {
      velocity.y = -velocity.y;
      location.y = height - 24;
    }
    else if (location.y  - 24 < 0) {
      velocity.y = -velocity.y;
      location.y = 24;
    }
  }
}
