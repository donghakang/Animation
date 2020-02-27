
Camera camera;
PShape spoon;
PShape plate;

float radius=50;
int numHeight=4;
int numPoints=500;
float angle=TWO_PI/(float)numPoints;

float floor = 400;
float anchorX = 200;
float anchorY = 50;
float restLen = 10;
float mass = 1;
float k = 7000;
float kv = 100;

color banana     = color(255, 255, 212);
color chocolate  = color(255, 202, 95);
Spring[][] pudding = new Spring[numHeight][numPoints];



void init() {
  for(int i=0; i < numHeight; i++) {
    for (int j=0; j < numPoints; j++) {
      pudding[i][j] = new Spring((radius-4*i)*sin(angle*j), 0-10*i, ((radius-4*i)*cos(angle*j))); 
    }
  }
}


void setup() {
  size(600, 600, P3D);
  surface.setTitle("Ball on Spring!");
  
  init();
  spoon = loadShape("data/spoon.obj");
  //spoon.translate(0,100,0);
  spoon.scale(0.08);
  spoon.rotate(PI, 0.0, 0.0, 1.0);
  
  plate = loadShape("data/Square_Plate_Large_obj.obj");
  plate.scale(8);
  plate.translate(0,-5,0);
  plate.rotate(PI, 0.0, 0.0, 1.0);
  camera = new Camera();
}


void update(float dt){
  Force_Normal(dt);
  
  for (int i = 0; i < numHeight; i ++) {
    for (int j = 0; j < numPoints; j ++) {
      pudding[i][j].updatePos(dt);
    }
  }
}


void keyPressed() {
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void mouseClicked() {
  init();
}


void draw() {
  background(255,230,230);
  camera.Update( 1.0/frameRate );
  //pointLight(200,180,50,0,-100,0);

  lights();
  pointLight(50,50,50, 500, -500, 500);
  
  for (int i = 0; i < 10; i++){
    update(1/(5*frameRate));
  }
  
  pushMatrix();
  beginShape();
  fill(banana);
  shininess(50); 
  noStroke();
  for (int j = 0; j < numPoints; j++) {
    vertex(pudding[0][j].pos.x, pudding[0][j].pos.y, pudding[0][j].pos.z);
  }
  endShape();
  popMatrix();
  
  pushMatrix();
  beginShape();
  fill(chocolate);
  shininess(50); 
  noStroke();
  for (int j = 0; j < numPoints; j++) {
    vertex(pudding[3][j].pos.x, pudding[3][j].pos.y, pudding[3][j].pos.z);
  }
  endShape();
  popMatrix();
  
  // PUDDING
  pushMatrix();
  for (int i = 0; i < numHeight-1; i ++) {
    for (int j = 0; j < numPoints; j++) {
      if (j == numPoints - 1) {
        beginShape();
        fill(banana);
        shininess(5.0); 
        noStroke();
        vertex(pudding[i][j].pos.x, pudding[i][j].pos.y, pudding[i][j].pos.z);
        vertex(pudding[i+1][j].pos.x, pudding[i+1][j].pos.y, pudding[i+1][j].pos.z);
        vertex(pudding[i+1][0].pos.x, pudding[i+1][0].pos.y, pudding[i+1][0].pos.z);
        vertex(pudding[i][0].pos.x, pudding[i][0].pos.y, pudding[i][0].pos.z);
        endShape();
      } else {
        beginShape();
        fill(banana);
        shininess(5.0); 
        noStroke();
        vertex(pudding[i][j].pos.x, pudding[i][j].pos.y, pudding[i][j].pos.z);
        vertex(pudding[i+1][j].pos.x, pudding[i+1][j].pos.y, pudding[i+1][j].pos.z);
        vertex(pudding[i+1][j+1].pos.x, pudding[i+1][j+1].pos.y, pudding[i+1][j+1].pos.z);
        vertex(pudding[i][j+1].pos.x, pudding[i][j+1].pos.y, pudding[i][j+1].pos.z);
        endShape();
      }
    }
  }
  popMatrix();
  
  // SPOON
  pushMatrix();
  shininess(20.0);
  //s.setFill(color(random(255),random(255),random(255)));
  translate((mouseX-300)/2, (mouseY-300)/2, 0);
  shape(spoon, 0, 0);
  popMatrix();
    
    
  // PLATE
  pushMatrix();
  shininess(100.0);
  plate.setFill(color(255,255,255));
  shape(plate, 0, 0);
  popMatrix();
  
  // TABLE
  pushMatrix();
  fill(color(133,94,66));
  translate(0,20,0);
  box(1000, 1, 1000);
  popMatrix();

}
