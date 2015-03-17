float speed,
  rotX, rotZ,
  positionX, positionY, diffX, diffY;
  
float depth = 2000, 
  boardThickness = 20,
  boardX = 500,
  boardY = 500,
  radius = 20;

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
  
  mover.update();
  mover.checkEdges();
  mover.display();
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
  if (keyCode == UP) {
    positionX += speed;
  }
  else if (keyCode == DOWN){
    positionX -= speed;
  }
}
