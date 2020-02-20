//2D Rotational Dynamics
//Ball on Spring (damped) - 2D Motion
//CSCI 5611 Thread Sample Code
// Stephen J. Guy <sjguy@umn.edu>

Camera camera;

void setup() {
  size(600, 600, P3D);
  surface.setTitle("Ball on Spring!");
  
  camera = new Camera();
  init();
}

float floor = 400;
float grav = 100; //0
//float radius = .5;
float anchorX = 200;
float anchorY = 50;
float restLen = 10;
float mass = 10;
float k = 1000; //1 1000
float kv = 1000;

int num = 20;
//ArrayList<ArrayList<Spring>> springs = new ArrayList<ArrayList<Spring>>();
Spring[][] springs = new Spring[num][num];


void init() {
  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num; j ++) {
      //springs.get(j).add(new Spring(200,50 + 5*i, 0));
      springs[i][j] = new Spring(100+10*i, 0, 50+5*j);
    }
  }
}


void update(float dt){
  
  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num -1; j ++) {
       Force(springs[i][j], springs[i][j+1], dt);
    }
  }
  
  for (int i = 0; i < num-1; i ++) {
    for (int j = 0; j < num; j ++) {
       Force(springs[i][j], springs[i+1][j], dt);
    }
  }
  
  
 
  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num; j ++) {
       springs[i][j].vel.y += grav * dt;
       //Force(springs[i][j], springs[i+1][j], dt);
    }
  }
  
  for (int i = 0; i < num; i++) {
    springs[i][0].vel.x = 0;
    springs[i][0].vel.y = 0;
    springs[i][0].vel.z = 0;
  }

  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num; j ++) {
      springs[i][j].updatePos(dt);
    }
  }
}

void keyPressed() {
  camera.HandleKeyPressed();
  
  if (keyCode == RIGHT) {
    springs[10][10].vel.x += 200;
  }
  if (keyCode == LEFT) {
    springs[10][10].vel.x -= 200;
  }
  if (keyCode == UP) {
    springs[10][10].vel.y -= 200;
  }
  if (keyCode == DOWN) {
    springs[10][10].vel.y += 200;
  }
  if (keyCode == 'R') {
    init();
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void draw() {
  background(255,255,255);
  lights();
  noStroke();
  for (int i = 0; i < 10; i++){
    update(1/(5*frameRate));
  }
  camera.Update( 1.0/frameRate );
  //update(0.1);
 
  println(camera.position, camera.theta, camera.phi);
 
  for (int i = 0; i < num - 1; i ++) {
    for (int j = 0; j < num - 1; j ++) {
      if (j % 2 == 0) {
        beginShape();
        fill(255, 125, 120);
        vertex(springs[i][j].pos.x, springs[i][j].pos.y, springs[i][j].pos.z);
        vertex(springs[i+1][j].pos.x, springs[i+1][j].pos.y, springs[i+1][j].pos.z);
        vertex(springs[i+1][j+1].pos.x, springs[i+1][j+1].pos.y, springs[i+1][j+1].pos.z);
        vertex(springs[i][j+1].pos.x, springs[i][j+1].pos.y, springs[i][j+1].pos.z);
        endShape();
      }
      else {
        beginShape();
        fill(255, 0, 0);
        vertex(springs[i][j].pos.x, springs[i][j].pos.y, springs[i][j].pos.z);
        vertex(springs[i+1][j].pos.x, springs[i+1][j].pos.y, springs[i+1][j].pos.z);
        vertex(springs[i+1][j+1].pos.x, springs[i+1][j+1].pos.y, springs[i+1][j+1].pos.z);
        vertex(springs[i][j+1].pos.x, springs[i][j+1].pos.y, springs[i][j+1].pos.z);
        endShape();
      }
    }
  }
    
}
