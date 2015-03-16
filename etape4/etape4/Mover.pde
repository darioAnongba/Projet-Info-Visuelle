float gravityConstant = 0.01;

class Mover {
  PVector location;
  PVector velocity;
  PVector gravityForce;
  
  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravityForce = new PVector(0, 0, 0);
  } 
  void update() {
    gravityForce.x = sin(rz) * gravityConstant;
    gravityForce.z = sin(rx) * gravityConstant;
    float normalForce = -1;
    float mu = 0.01;
    float frictionMagnitude = normalForce * mu;
    PVector friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    System.out.println("grav force: " + gravityForce);
    System.out.println("friction: " + friction);
    velocity.add(gravityForce);
    //velocity.add(friction);
    location.add(velocity);
  }  

  void display() {
    pushMatrix();
      translate(width/2, height/2, 0);
      rotateZ(rz);
      rotateX(rx);
      box(boardX, boardThickness, boardY);
      pushMatrix();
        lights();
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
    else if (location.x  - radius < -boardX/2) {
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
