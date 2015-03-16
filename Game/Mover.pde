class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
  PVector friction;
  
  float gravityConstant = 0.1,
    frictionMagnitude,
    mu = 0.01,
    normalForce = 1;
  
  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    friction = new PVector(0, 0, 0);
  }
  
  void update() {
    gravity.x = sin(rotX) * gravityConstant;
    gravity.z = sin(rotZ) * gravityConstant;

    frictionMagnitude = normalForce * mu;
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    velocity.add(gravity);
    velocity.add(friction);
    location.add(velocity);
  }  

  void display() {
    pushMatrix();
      translate(width/2, height/2, 0);
      rotateZ(rotZ);
      rotateX(rotX);
      box(boardX, boardThickness, boardY);
      pushMatrix();
        translate(location.x, -boardThickness/2-radius, location.z);
        sphere(radius);
      popMatrix();
    popMatrix();
  }

  void checkEdges() {
    if (location.x + radius > boardX/2) {
      velocity.x = -velocity.x;
      location.x = boardX/2 - radius;
    }
    else if (location.x - radius < -boardX/2) {
      velocity.x = -velocity.x;
      location.x = -boardX/2 + radius;
    }
    if (location.z + radius > boardY/2) {
      velocity.z = -velocity.z;
      location.z = boardY/2 - radius;
    }
    else if (location.z - radius < -boardY/2) {
      velocity.z = -velocity.z;
      location.z = -boardY/2 + radius;
    }
  }
}
