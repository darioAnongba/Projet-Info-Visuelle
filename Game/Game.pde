float speed,
  rotX, rotZ,
  positionX, positionY,
  diffX, diffY,
  toDrawX, toDrawY;
  
float depth = 2000, 
  boardThickness = 20,
  boardX = 500,
  boardY = 500,
  radius = 20;
  
boolean released = true,
  somethingToDraw = false;

PFont f;

Mover mover;

void setup() {
  speed = 0.2;
  
  size(800, 800, P3D);
  frameRate(100); 
  f = createFont("Arial",16,true);
  
  mover = new Mover();
}

void draw() {
  background(255);
  
  if(!released){
      pushMatrix();
        rect(width/2-(boardX/2), height/2-(boardY/2), boardX, boardY);
        translate(mouseX, mouseY, 30);
        drawCylinder(50, 40, 40, 60);
      popMatrix();
      
      if(somethingToDraw){
        pushMatrix();
          translate(toDrawX, toDrawY, 30);
          drawCylinder(50, 40, 40, 60);
        popMatrix();
      }
  }
  else {   
    mover.update();
    mover.checkEdges();
    mover.display();
  }
}

void mouseDragged() {
  diffX += map(mouseX, 0, width, -PI/3, PI/3) - map(pmouseX, 0, width, -PI/3, PI/3);
  diffY += map(mouseY, 0, height, -PI/3, PI/3) - map(pmouseY, 0, height, -PI/3, PI/3);
  
  rotZ = clamp(diffX, -PI/3, PI/3);
  rotX = clamp(diffY, -PI/3, PI/3);
}

private float clamp(float value, float min, float max) {
  if (value > max) return max;
  else if (value < min) return min;
  else return value;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speed = clamp(speed + e/100, 0.2, 1.5);
}

void keyPressed(){
  if (keyCode == LEFT) {
    positionY += speed;
  }
  else if (keyCode == RIGHT){
    positionY -= speed;
  }
  else if (keyCode == UP) {
    positionX += speed;
  }
  else if (keyCode == DOWN){
    positionX -= speed;
  }
  else if (keyCode == SHIFT){
    released = false;
  }
}

void keyReleased(){
  if(keyCode == SHIFT){
    released = true;
  }
}

void mouseClicked(){
  somethingToDraw = true;
  toDrawX = mouseX;
  toDrawY = mouseY;
}

void drawCylinder( int sides, float r1, float r2, float h)
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
}
