class Cylinder{
  private final float sides = 50;
  public static final float r1 = 40;
  public static final float r2 = 40;
  public static final float h = 60;
  
  PVector location;
  
  Cylinder(float x, float z) {
    location = new PVector(x, 0, z);
  }
  
  public void drawCylinder()
  {
      float angle = 360 / sides;
      float halfHeight = h / 2;
      // top
      beginShape();  
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r1;
          float y = sin( radians( i * angle ) ) * r1;
          vertex( x, y, -halfHeight);
      }
      endShape(CLOSE);
      // bottom
      beginShape();
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r2;
          float y = sin( radians( i * angle ) ) * r2;
          vertex( x, y, halfHeight);
      }
      endShape(CLOSE);
      // draw body
      beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < sides + 1; i++) {
          float x1 = cos( radians( i * angle ) ) * r1;
          float y1 = sin( radians( i * angle ) ) * r1;
          float x2 = cos( radians( i * angle ) ) * r2;
          float y2 = sin( radians( i * angle ) ) * r2;
          vertex( x1, y1, -halfHeight);
          vertex( x2, y2, halfHeight);
      }
      endShape(CLOSE);
      //noFill();
  }
  
  public void display3D() {
    pushMatrix();
      //translate(location.x - width/2, -(BOARD_THICKNESS/2 + Cylinder.h/2), location.z - height/2);
      translate(location.x - width/2, -(BOARD_THICKNESS/2), location.z - height/2);
      rotateX(PI);
      shape(tree);
      //rotateX(PI/2);
      //drawCylinder(); 
    popMatrix();
  }
  
  public void display2D() {
    pushMatrix();
      translate(location.x,location.z, h/2);
      rotateX(PI/2);
      shape(tree);
      //drawCylinder(); 
    popMatrix();
  }
}
