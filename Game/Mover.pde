class Mover {
  PVector location;
  PVector velocity;
  PVector gravity;
  PVector friction;
  
  float gravityConstant = 0.15,
    frictionMagnitude,
    mu = 0.02,
    normalForce = 1,
    elasticity = 0.7;
  
  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    friction = new PVector(0, 0, 0);
  }
  
  void update() {
    gravity.x = sin(rotZ) * gravityConstant;
    gravity.z = -sin(rotX) * gravityConstant;

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
      velocity.x = -velocity.x * elasticity;
      location.x = boardX/2 - radius;
    }
    else if (location.x - radius < -boardX/2) {
      velocity.x = -velocity.x * elasticity;
      location.x = -boardX/2 + radius;
    }
    if (location.z + radius > boardY/2) {
      velocity.z = -velocity.z * elasticity;
      location.z = boardY/2 - radius;
    }
    else if (location.z - radius < -boardY/2) {
      velocity.z = -velocity.z * elasticity;
      location.z = -boardY/2 + radius;
    }
  }
}
