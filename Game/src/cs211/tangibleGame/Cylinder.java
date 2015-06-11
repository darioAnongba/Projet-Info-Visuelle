package cs211.tangibleGame;
import processing.core.*;

class Cylinder extends PApplet {
  
  private static final long serialVersionUID = 1L;
  
  private final float sides = 50;
  public static final float r1 = 25;
  public static final float r2 = 25;
  public static final float h = 60;
  
  protected PVector location;
  PApplet parent;
  
  Cylinder(float x, float z, PApplet p) {
    location = new PVector(x, 0, z);
    parent = p;
  }
  
  public void drawCylinder()
  {
      float angle = 360 / sides;
      float halfHeight = h / 2;
      // top
      parent.beginShape();  
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r1;
          float y = sin( radians( i * angle ) ) * r1;
          parent.vertex( x, y, -halfHeight);
      }
      parent.endShape(CLOSE);
      // bottom
      parent.beginShape();
      for (int i = 0; i < sides; i++) {
          float x = cos( radians( i * angle ) ) * r2;
          float y = sin( radians( i * angle ) ) * r2;
          parent.vertex( x, y, halfHeight);
      }
      parent.endShape(CLOSE);
      // draw body
      parent.beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < sides + 1; i++) {
          float x1 = cos( radians( i * angle ) ) * r1;
          float y1 = sin( radians( i * angle ) ) * r1;
          float x2 = cos( radians( i * angle ) ) * r2;
          float y2 = sin( radians( i * angle ) ) * r2;
          vertex( x1, y1, -halfHeight);
          vertex( x2, y2, halfHeight);
      }
      parent.endShape(CLOSE);
  }
  
  public void display3D() {
    parent.pushMatrix();
      parent.translate(location.x - parent.width/2, -10, location.z - parent.height/2);
      parent.shape(TangibleGame.olaf);
    parent.popMatrix();
  }
  
  public void display2D() {
    parent.pushMatrix();
      parent.translate(location.x,location.z, h/2);
      parent.rotateX(-PI/2);
      parent.shape(TangibleGame.olaf);
    parent.popMatrix();
  }
}
