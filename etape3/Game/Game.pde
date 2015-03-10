float positionX, positionY, speed;
PFont f;
void setup()  {
  size(800, 800, P3D);
  noStroke();
  fill(204);
  
  positionX = -PI/6;
  positionY = PI/3;
  speed = 0.2;
  
  f = createFont("Arial",16,true);
}

void draw()  {
  background(255);
  lights();
  ambient(20);
  pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(positionX); 
    rotateY(positionY); 
    box(400, 20, 400);
  popMatrix();
  
  textFont(f,16);
  text ("speed : "+ speed + "" , 0, 16);
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

void mouseDragged(){
  
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
   speed += e/100;
}
