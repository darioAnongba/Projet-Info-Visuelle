// Board values
final int BOARD_THICKNESS = 20;
final int BOARD_SIZE = 700;
float rotX, rotY, rotZ;
float diffX, diffY;
float speed;
float score, lastScore;
double time;

// Ball values
final int BALL_RADIUS = 20;

// Global values
final int DEPTH = 2000;
final float miniRectSize = 10.0;
boolean interactionMode, canAddCylinder;
Mover ball;
Cylinder cylinder;
ArrayList<Cylinder> cylinders;
ArrayList<Float> scores;
PGraphics dataVisualization, topView, scoreboard, barChart;
HScrollbar hs;
PShape tree;

void setup() {
  size(800, 600, P3D);
  frameRate(100);

  rotX = 0;
  rotY = 0;
  rotZ = 0;
  speed = 0.1;
  interactionMode = false;
  canAddCylinder = false;
  ball = new Mover();
  cylinder = new Cylinder(0, 0);
  cylinders = new ArrayList();
  scores = new ArrayList();
  score = 0.0;
  lastScore = 0.0;
  time = 0.0;
  
  dataVisualization = createGraphics(width, height/5, P2D);
  topView = createGraphics(width/7, height/5, P2D);
  scoreboard = createGraphics(width/7, height/5, P2D);
  barChart = createGraphics(5*width/7, height/5, P2D);
  hs = new HScrollbar(5*width/7/2 - 40, 4*height/5+100, 550, 13);
  
  tree = loadShape("test.obj");
  tree.scale(40);
}

void draw() {
  background(0, 191, 243);
  time += 0.001;
  if(interactionMode){
    interactionMode();
    ball.displayBall2D();
  }
  else {
    pushMatrix();
      camera(width/2, -height/2, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
      translate(width/2, height/2, 0);
      rotateZ(rotZ);
      rotateX(rotX);
      stroke(0);
      fill(255, 245, 104);
      box(BOARD_SIZE, BOARD_THICKNESS, BOARD_SIZE);
      noStroke();
      
      ball.update();
      ball.checkEdges();
      ball.checkCylinderCollision();
      ball.displayBall3D();
     
      drawCylinders(true);
    popMatrix();
    
    pushMatrix();
      drawDataVisualization();
      image(dataVisualization, 0, 4.0/5.0*height);
    popMatrix();
    
    pushMatrix();
      drawTopView();
      image(topView, 0, 4.0/5.0*height);
    popMatrix();
    
    pushMatrix();
      drawScoreboard();
      image(scoreboard, BOARD_SIZE/7.0 + 20, 4.0/5.0*height);
    popMatrix();
    
    pushMatrix();
      drawBarChart();
      image(barChart, 2*BOARD_SIZE/7.0 + 20 + 20, 4.0/5.0*height + 5);
    popMatrix();
    
    pushMatrix();
      hs.update();
      hs.display();
    popMatrix();
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
  if (keyCode == LEFT)
    rotY += speed;
  else if (keyCode == RIGHT)
    rotY -= speed;
  else if (keyCode == SHIFT)
    interactionMode = true;
  else if (keyCode == UP){
    System.out.println();
  }
}

void keyReleased(){
  if(keyCode == SHIFT)
    interactionMode = false;
}

void mouseClicked(){
  if(interactionMode && canAddCylinder){
    cylinders.add(new Cylinder(mouseX, mouseY));
  }
}

void interactionMode(){
  camera(width/2, height/2, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  Cylinder cylinderThatFollows = new Cylinder(0, 0);
  float sizeSideX = (width - BOARD_SIZE) / 2;
  float sizeSideY = (height - BOARD_SIZE) / 2;
  
  pushMatrix();
    fill(255, 245, 104);
    stroke(0);
    rect(width/2-(BOARD_SIZE/2), height/2-(BOARD_SIZE/2), BOARD_SIZE, BOARD_SIZE);
    noStroke();
    float positionBallX = ball.location.x + width/2;
    float positionBallZ = ball.location.z + height/2;
    // If we are outside the board or if we want to draw over the ball
    if(mouseX >= sizeSideX + Cylinder.r1 && mouseX <= width - sizeSideX - Cylinder.r1
     && mouseY >= sizeSideY + Cylinder.r1 && mouseY <= height - sizeSideY - Cylinder.r1
     && BALL_RADIUS + Cylinder.r1 <= sqrt(pow(mouseX-positionBallX, 2) + pow(mouseY-positionBallZ, 2))
     && canAddCylinder()
     ){
      canAddCylinder = true;
      translate(mouseX, mouseY, Cylinder.h/2);
      directionalLight(20, 20, 40, -1, 0, 1);
      //fill(220, 220, 220);
      rotateX(PI/2);
      shape(tree);
      //cylinderThatFollows.drawCylinder();
    }
    else {
      canAddCylinder = false;
    }
  popMatrix();
  
  // Draw all the cylinders on the board
  directionalLight(20, 20, 40, -1, 0, 1);
  fill(62, 168, 50);
  for(Cylinder cylinder: cylinders){
    cylinder.display2D();
  }
}

void drawCylinders(boolean is3D) {
  directionalLight(20, 20, 40, -1, 0, 1);
  fill(220, 220, 220);
  for(Cylinder cylinder: cylinders) {
    if(is3D)
      cylinder.display3D();
    else
      cylinder.display2D();
  }
}

boolean canAddCylinder(){
  boolean toReturn = true;
  for(Cylinder c: cylinders){
      toReturn &= 2*Cylinder.r1 <= sqrt(pow(mouseX - c.location.x, 2) + pow(mouseY - c.location.z, 2));
  }
  return toReturn;
}

void drawDataVisualization(){
  lights();
  dataVisualization.beginDraw();
  dataVisualization.background(102);
  dataVisualization.fill(240, 213, 183);
  //dataVisualization.strokeWeight(1);
  dataVisualization.stroke(255);
  dataVisualization.rect(0, 0, width, height/5);
  dataVisualization.endDraw();
}

void drawTopView(){
  lights();
  topView.beginDraw();
  //topView.background(12);
  topView.fill(255, 245, 104);
  //topView.strokeWeight(1);
  topView.stroke(255);
  topView.rect(10, 10, BOARD_SIZE/7, BOARD_SIZE/7);
  topView.fill(246, 142, 86);
  float positionBallX = ball.location.x + width/2;
  float positionBallZ = ball.location.z + height/2;
  topView.noStroke();
  topView.ellipse(10/3.5 + (positionBallX) / 7.0, 15 + 10/3.5 + (positionBallZ) / 7.0, BALL_RADIUS/3.5, BALL_RADIUS/3.5); //tailles a voir
  topView.fill(220, 220, 220);
  for (Cylinder c : cylinders) {
    topView.ellipse(10/3.5 + (c.location.x) / 7.0, 15 + 10/3.5 + c.location.z / 7.0, Cylinder.r1 / 3.5, Cylinder.r2 / 3.5); //tailles à voir
  }
  topView.endDraw();
}

void drawScoreboard(){
  lights();
  scoreboard.beginDraw();
  scoreboard.stroke(255);
  String s = "Total score:\n" + round(score*1000.0)/1000.0 + "\nVelocity:\n" + round(sqrt(pow(ball.velocity.x, 2) + pow(ball.velocity.z, 2))*1000.0)/1000.0 + "\nLast score:\n" + round(lastScore*1000.0)/1000.0;
  scoreboard.fill(240, 213, 183);
  scoreboard.rect(10, 10, BOARD_SIZE/7, BOARD_SIZE/7);
  scoreboard.fill(50);
  scoreboard.text(s, 15, 15, BOARD_SIZE/7 - 15, BOARD_SIZE/7 - 15);
  scoreboard.endDraw();
}

void drawBarChart(){
  lights();
  barChart.beginDraw();
  barChart.stroke(240, 213, 183);
  barChart.fill(200, 213, 183);
  barChart.rect(0, 0, 5*width/7, height/5/2 + 30);
  barChart.fill(240, 180, 183);
  if (time*1000 % 1000 < 0.1 ) {
    scores.add(score);
  }
  for (int i = 0; i < scores.size(); i++) {
    for (int j = 0; j < max(0, scores.get(i)) / 10; j++) {
      barChart.rect(i*miniRectSize+10, height/5/2+30-(j+1)*miniRectSize, miniRectSize*hs.getPos(), miniRectSize);
    }
  }
  barChart.endDraw();
}