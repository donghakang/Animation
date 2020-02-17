//Triple Spring (damped) - 1D Motion
//CSCI 5611 Thread Sample Code
// Stephen J. Guy <sjguy@umn.edu>

//Create Window
void setup() {
  size(600, 600, P3D);
  surface.setTitle("Ball on Spring!");
  
  init();
}

//Simulation Parameters
float floor = 600;
float gravity = 10;
float radius = 5;
float stringTop = 50;
float restLen = 40;
float mass = 20; //TRY-IT: How does changing mass affect resting length?
float k = 500; //TRY-IT: How does changing k affect resting length?
float kv = 100;

int num = 10;


ArrayList<Spring> springs = new ArrayList<Spring>();;

void init() {
  for (int i = 0; i < num; i += 1) {
    Spring s = new Spring(300, 200 + 50*i);
    springs.add(s);
  }
}

void reset() {
  for (int j = num - 1; j >= 0; j -= 1) {
    springs.remove(j);
  }
  for (int i = 0; i < num; i += 1) {
    Spring s = new Spring(300, 200 + 50*i, 0, 0);
    springs.add(s);
  }
}


void update(float dt){
  for (int j = 0; j < num; j += 1) {
    Spring s = springs.get(j);
    if (j == 0) {
      s.yForce(stringTop, 0);
    } else {
      s.yForce(springs.get(j-1).ballY, springs.get(j-1).velY);
    }
  }
  

  for (int k = 0; k < num; k += 1) {
    Spring s = springs.get(k);
    if (k == num - 1) {
      s.accelerationY(0, dt);
    }
    else {
      s.accelerationY(springs.get(k+1).forceY, dt);
    }
  }

}




void keyPressed() {
  if (keyCode == DOWN) {
    springs.get(0).velY += 500;
  }
  if (keyCode == UP) {
    springs.get(0).velY -= 500;
  }
  if (keyCode == RIGHT) {
    // velX  += 30
  }
  if (keyCode == LEFT) {
    // velY  -= 30
  }
  if (keyCode == 'R') {
    reset();
  }
}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  update(.1); //We're using a fixed, large dt -- this is a bad idea!!
  fill(0,0,0);
  
  for (int i = 0; i < num; i ++) {
    springs.get(i).appear();
  }
}
