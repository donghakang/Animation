//Ball on Spring (damped) - 2D Motion
//CSCI 5611 Thread Sample Code
// Stephen J. Guy <sjguy@umn.edu>

//Create Window
//2D Rotational Dynamics
void setup() {
  size(600, 600, P3D);
  surface.setTitle("Ball on Spring!"); 
}

//Simulation Parameters
float floor = 400;
float grav = 98;
float radius = 20;
float anchorX = 300;
float anchorY = 100;
float restLen = 100;
float k = 1000; //1 1000
float mass = 50;
float kv = 100;

//Inital positions and velocities of masses
//float ballY = 100; //200
//float ballX = 100; //200
//float velY = 0;
//float velX = 0;
float ballY1 = 100; //200
float ballX1 = 200; //200
float velY1 = 0;
float velX1 = 0;

float ballY2 = 150; //200
float ballX2 = 300; //200
float velY2 = 0;
float velX2 = 0;

float ballY3 = 200; //200
float ballX3 = 300; //200
float velY3 = 0;
float velX3 = 0;

void update(float dt){

  float sx1 = (ballX1 - anchorX);
  float sy1 = (ballY1 - anchorY);
  float stringLen1 = sqrt(sx1*sx1 + sy1*sy1); 
  float stringF1 = -k*(stringLen1 - restLen); 
  float dirX1 = sx1/stringLen1;
  float dirY1 = sy1/stringLen1;
  float projVel1 = velX1*dirX1 + velY1*dirY1; 
  float dampF1 = -kv*(projVel1 - 0);
  float springForceX1 = (stringF1+dampF1)*dirX1; 
  float springForceY1 = (stringF1+dampF1)*dirY1;
  
  velX1 += (springForceX1/mass)*dt;
  velY1 += ((springForceY1+grav)/mass)*dt;
  ballX1 += velX1*dt;
  ballY1 += velY1*dt;
  
  float sx2 = (ballX2 - ballX1);
  float sy2 = (ballY2 - ballY1);
  float stringLen2 = sqrt(sx2*sx2 + sy2*sy2); 
  float stringF2 = -k*(stringLen2 - restLen); 
  float dirX2 = sx2/stringLen2;
  float dirY2 = sy2/stringLen2;
  float projVel2 = velX2*dirX2 + velY2*dirY2; 
  float dampF2 = -kv*(projVel2 - projVel1);
  float springForceX2 = (stringF2+dampF2)*dirX2; 
  float springForceY2 = (stringF2+dampF2)*dirY2;
  
  velX2 += (springForceX2/mass)*dt;
  velY2 += ((springForceY2+grav)/mass)*dt;
  ballX2 += velX2*dt;
  ballY2 += velY2*dt;
  
  float sx3 = (ballX3 - ballX2);
  float sy3 = (ballY3 - ballY2);
  float stringLen3 = sqrt(sx3*sx3 + sy3*sy3); 
  float stringF3 = -k*(stringLen3 - restLen); 
  float dirX3 = sx3/stringLen3;
  float dirY3 = sy3/stringLen3;
  float projVel3 = velX3*dirX3 + velY3*dirY3; 
  float dampF3 = -kv*(projVel3 - projVel2);
  float springForceX3 = (stringF3+dampF3)*dirX3; 
  float springForceY3 = (stringF3+dampF3)*dirY3;
  
  velX3 += (springForceX3/mass)*dt;
  velY3 += ((springForceY3+grav)/mass)*dt;
  ballX3 += velX3*dt;
  ballY3 += velY3*dt;

}

//Allow the user to push the mass with the left and right keys
void keyPressed() {
  if (keyCode == RIGHT) {
    velX1 += 30;
  }
  if (keyCode == LEFT) {
    velX1 -= 30;
  }
}

//Draw the scene: one sphere for the mass, and one line connecting it to the anchor
void draw() {
  background(255,255,255);
  update(.15); //We're using a fixed, large dt -- this is a bad idea!!
  fill(0,0,0);
  
  
  pushMatrix();
  stroke(5);
  line(anchorX,anchorY,ballX1,ballY1);
  popMatrix();
  
  pushMatrix();
  translate(ballX1,ballY1);
  noStroke();
  fill(0,200,10);
  sphere(radius);
  popMatrix();
  
  pushMatrix();
  stroke(5);
  line(ballX1,ballY1,ballX2,ballY2);
  popMatrix();
  
  pushMatrix();
  translate(ballX2,ballY2);
  noStroke();
  fill(0,200,10);
  sphere(radius);
  popMatrix();
  
  
  pushMatrix();
  stroke(5);
  line(ballX2,ballY2,ballX3,ballY3);
  popMatrix();
  
  pushMatrix();
  translate(ballX3,ballY3);
  noStroke();
  fill(0,200,10);
  sphere(radius);
  popMatrix();
  
}
