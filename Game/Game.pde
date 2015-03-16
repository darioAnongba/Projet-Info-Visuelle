float speed,
  rotX, rotZ,
  positionX, positionY;
  
float depth = 2000, 
  boardThickness = 20,
  boardX = 500,
  boardY = 500,
  radius = 28;

PFont f;

Mover mover;

void setup() {
  speed = 0.2;
  
  size(1000, 1000, P3D);
  frameRate(80); 
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
  rotZ = clamp(map(mouseX*(1+speed), 0, width, -PI/3, PI/3), -PI/3, PI/3);
  rotX = clamp(map(mouseY*(1+speed), 0, height, -PI/3, PI/3), -PI/3, PI/3);
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
  if(keyCode == LEFT) {
    positionY += speed;
  }
  else if (keyCode == RIGHT){
    positionY -= speed;
  }
  if(keyCode == UP) {
    positionX += speed;
  }
  else if (keyCode == DOWN){
    positionX -= speed;
  }
}
