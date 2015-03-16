float depth = 2000;
float speed;
float rx, rz;
float positionX, positionY;
float boardThickness = 20;
float boardX = 400;
float boardY = 400;
float radius = 48;
PFont f;

Mover mover;

void setup() {
  mover = new Mover();
  frameRate(80);
  speed = 0.2;
  size(800, 800, P3D);
  noStroke();
  fill(204);

  f = createFont("Arial",16,true);
}

void draw() {
  background(255);
  lights();
  ambient(20);
  mover.update();
  mover.checkEdges();
  mover.display();
  
  textFont(f,16);
  text ("speed : "+ speed + "" , 0, 16);
}

void mouseDragged() {
  rz = clamp(map(mouseX*(1+speed), 0, width, -PI/3, PI/3), -PI/3, PI/3);
  rx = clamp(map(mouseY*(1+speed), 0, height, -PI/3, PI/3), -PI/3, PI/3);
}

float clamp(float value, float min, float max) {
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
