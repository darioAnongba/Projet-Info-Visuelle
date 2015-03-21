class Mover {
  private final float GRAVITY_CONSTANT = 0.15;

  private PVector location, velocity, gravity, friction;
  private float frictionMagnitude, mu, normalForce, elasticity;
  
  Mover() {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(0, 0, 0);
    friction = new PVector(0, 0, 0);
    
    frictionMagnitude = 0;
    mu = 0.02;
    normalForce = 1;
    elasticity = 0.7;
  }
  
  void update() {
    gravity.x = sin(rotZ) * GRAVITY_CONSTANT;
    gravity.z = -sin(rotX) * GRAVITY_CONSTANT;

    frictionMagnitude = normalForce * mu;
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    velocity.add(gravity);
    velocity.add(friction);
    location.add(velocity);
  }  

  void displayBall3D() {
      pushMatrix();
        translate(location.x, -BOARD_THICKNESS/2-BALL_RADIUS, location.z);
        sphere(BALL_RADIUS);
      popMatrix();      
  }
  
  void displayBall2D() {
     pushMatrix();
      translate(location.x + width/2, location.z + height/2, BALL_RADIUS);
      sphere(BALL_RADIUS);
     popMatrix(); 
  }

  void checkEdges() {
    if (location.x + BALL_RADIUS > BOARD_SIZE/2) {
      velocity.x = -velocity.x * elasticity;
      location.x = BOARD_SIZE/2 - BALL_RADIUS;
    }
    else if (location.x - BALL_RADIUS < -BOARD_SIZE/2) {
      velocity.x = -velocity.x * elasticity;
      location.x = -BOARD_SIZE/2 + BALL_RADIUS;
    }
    if (location.z + BALL_RADIUS > BOARD_SIZE/2) {
      velocity.z = -velocity.z * elasticity;
      location.z = BOARD_SIZE/2 - BALL_RADIUS;
    }
    else if (location.z - BALL_RADIUS < -BOARD_SIZE/2) {
      velocity.z = -velocity.z * elasticity;
      location.z = -BOARD_SIZE/2 + BALL_RADIUS;
    }
  }
  
  void checkCylinderCollision(){
      for(Cylinder c: cylinders) {
        float cX = c.location.x - width/2;
        float cZ = c.location.z - height/2;
        if(Cylinder.r1 + BALL_RADIUS >= sqrt(pow(location.x - cX, 2) + pow(location.z - cZ, 2)) ) {
          PVector n = new PVector(location.x - cX, 0, location.z - cZ);
          n.normalize();
          location.x = cX + n.x * (BALL_RADIUS + Cylinder.r1);
          location.z = cZ + n.z * (BALL_RADIUS + Cylinder.r1);
          float scal = velocity.dot(n) * 2;
          n.mult(scal);
          velocity.sub(n);
          velocity.mult(0.8);
        }
      }
  }
}
