float depth = 2000;
float speed;
float rx, rz;
float positionX, positionY;
PFont f;

void setup() {
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
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateZ(rz);
  rotateX(rx);
  box(400, 20, 400);
  popMatrix();
  
  textFont(f,16);
  text ("speed : "+ speed + "" , 0, 16);
}

void mouseDragged() {
  rz = clamp(map(mouseX*(1+speed), 0, width, -PI/3, PI/3), -PI/3, PI/3);
  System.out.println("rz = " + rz);
  rx = clamp(map(mouseY*(1+speed), 0, height, -PI/3, PI/3), -PI/3, PI/3);
  System.out.println("rx = " + rx);
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
