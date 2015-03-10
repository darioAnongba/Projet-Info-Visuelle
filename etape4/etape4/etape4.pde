Mover mover;
void setup() {
  size(800,800);
  mover = new Mover();
  frameRate(120);
}

void draw() {
  background(255);
  mover.update();
  mover.checkEdges();
  mover.display();
}
