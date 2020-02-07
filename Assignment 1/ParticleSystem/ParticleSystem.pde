//
// Dongha Kang
// Particle System

import peasy.*;
PeasyCam cam;

String projectTitle = "Particle System";



static float gravity = 9.8;

int status = 1;

float genRate    = 1000.0;

//float genRate = 5;
float dt         = 1;
int numParticles = 0;
float maxLife    = 20.0;
float maxFire    = 20.0;

float radius = 10.0;
float w      = 10.0;
float h      = 10.0;


color backgroundColor = color(255, 255, 200);

Obstacle o = new Obstacle();



void setup() {
  size(600, 600, P3D);

  beginCamera();
  camera();
  translate(200, 200, 0);
  rotateY(-PI/4);
  endCamera();
    

  //noStroke();
  surface.setTitle(projectTitle); 

}


void keyPressed() {
  // water 
  if (key==CODED){
    if (keyCode == SHIFT) {
      translation = true;
    }
  } else {
    if (keyCode == '1') {
      beginCamera();
      camera();
      translate(200, 200, 0);
      rotateY(-PI/4);
      endCamera();
      resetWater();
      backgroundColor = color(255, 255, 200);
      status = 1;
    } 
    // fire
    else if (keyCode == '2') {
      beginCamera();
      camera();
      translate(camX, camY, camZ);
      endCamera();
      resetFire();
      backgroundColor = color(0, 0, 0);
      //maxLife = 10000;
      status = 2;
    } 
  }
}

void keyReleased(){
  if (key==CODED){
    if (keyCode == SHIFT) translation = false;
  }
}



void draw() {
  float startFrame = millis();
  background(backgroundColor);
  lights();
  
  String runtimeReport = "";
  // water
  if (status == 1) {
    Human();
    Floor();
    WaterScene();
     
    Obstacle();
     
    runtimeReport = "Particles: "+str(particles.size())+","+
        " FPS: "+ str(round(frameRate)) +"\n";
  }
  else if (status == 2) {
    fireCamera();
    Log();
    FireScene();
    runtimeReport = "Particles: "+str(fires.size() + sparks.size() + smoke.size())+","+
        " FPS: "+ str(round(frameRate)) +"\n";
  }
  
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
}
