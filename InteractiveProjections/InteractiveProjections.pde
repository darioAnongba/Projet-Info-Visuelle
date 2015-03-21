float rotX, rotY, scale;

void setup () {
  size(1000,1000,P2D);
  rotX = 0;
  rotY = 0;
  scale = 1.0;
}
void draw() {
  background(255, 255, 255);
  
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  
  //initial scale
  float[][] transformScaleMouse = scaleMatrix(scale, scale, scale);
  input3DBox = transformBox(input3DBox, transformScaleMouse); 
  
  float[][] transform1 = rotateXMatrix(PI/8 + rotX);
  float[][] transformY = rotateYMatrix(rotY);
  
  input3DBox = transformBox(input3DBox, transform1);
  input3DBox = transformBox(input3DBox, transformY);
  
  float[][] transform2 = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, transform2);
  
  //rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(2, 2, 2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  return new My2DPoint(-(p.x - eye.x)*eye.z/(p.z-eye.z), -(p.y - eye.y)*eye.z/(p.z-eye.z));
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    int[][] tab = {{0, 1}, {1, 2}, {2, 3}, {0, 3}, {0, 4}, {1, 5}, {2, 6}, {3, 7}, {4, 5}, {4, 7}, {5, 6}, {6, 7}};
    for (int[] tuple : tab) {
      line(s[tuple[0]].x, s[tuple[0]].y, s[tuple[1]].x, s[tuple[1]].y);
    }
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{ new My3DPoint(x, y+dimY, z+dimZ),
                              new My3DPoint(x, y, z+dimZ),
                              new My3DPoint(x+dimX, y, z+dimZ),
                              new My3DPoint(x+dimX, y+dimY, z+dimZ),
                              new My3DPoint(x, y+dimY, z),
                              origin,
                              new My3DPoint(x+dimX, y, z),
                              new My3DPoint(x+dimX, y+dimY, z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] toReturn = new My2DPoint[box.p.length];
  for (int i = 0; i < box.p.length; i++) {
    toReturn[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(toReturn);
}
  
float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;
}

float[][] rotateXMatrix(float angle) {
  return new float[][]{{1, 0, 0, 0},
           {0, cos(angle), sin(angle), 0},
           {0, -sin(angle), cos(angle), 0},
           {0, 0, 0, 1}};
}

float[][] rotateYMatrix(float angle) {
  return new float[][]{{cos(angle), 0, -sin(angle), 0},
           {0, 1, 0, 0},
           {sin(angle), 0, cos(angle), 0},
           {0, 0, 0, 1}};
}

float[][] rotateZMatrix(float angle) {
  return new float[][]{{cos(angle), sin(angle), 0, 0},
           {-sin(angle), cos(angle), 0, 0},
           {0, 0, 1, 0},
           {0, 0, 0, 1}};
}

float[][] scaleMatrix(float x, float y, float z) {
  return new float[][]{{x, 0, 0, 0},
           {0, y, 0, 0},
           {0, 0, z, 0},
           {0, 0, 0, 1}};
}

float[][] translationMatrix(float x, float y, float z) {
  return new float[][]{{1, 0, 0, x},
           {0, 1, 0, y},
           {0, 0, 1, z},
           {0, 0, 0, 1}};
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] toReturn = new float[a.length];
  for (int i = 0; i < a.length; i++) {
    for (int j = 0; j < b.length; j++) {
      toReturn[i] += b[j] * a[i][j];
    }
  }
  return toReturn;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] toReturn = new My3DPoint[box.p.length];
  for (int i = 0; i < box.p.length; i++) {
    float[] tab = new float[]{box.p[i].x, box.p[i].y, box.p[i].z, 1};
    toReturn[i] = euclidian3DPoint(matrixProduct(transformMatrix, tab));
  }
  return new My3DBox(toReturn);
}

My3DPoint euclidian3DPoint(float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}

void mouseDragged() {
  if(pmouseY < mouseY) 
    scale -= 0.1;
  else 
    scale += 0.1;  
}

void keyPressed() {
    if (keyCode == UP) {
      rotX += 0.1;
    }
    else if (keyCode == DOWN) {
      rotX -= 0.1;
    }
    else if (keyCode == RIGHT) {
      rotY -= 0.1;
    }
    else if (keyCode == LEFT) {
      rotY += 0.1;
    }
}
