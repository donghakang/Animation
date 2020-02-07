// Dongha Kang
// January, 2020
// CSCI 5611

String projectTitle = "Bouncing Ball";


float positionX = 100;
float positionY = 200;

float velocity = 0;
float radius   = 40; 
float floor    = 600;
float wall     = 600;
float x_speed  = 10;

Boolean right_direction = true;

void setup() {
  size(600, 600, P3D);
  noStroke();            // Disables drawing the stroke (outline). 
                         // If both noStroke() and noFill() are called, nothing will be drawn to the screen.
}

//Animation Principle: Separate Physical Update 
void computePhysics(float dt){
  float acceleration = 9.8;
  
  //Eulerian Numerical Integration
  //Question: Why update position before velocity? Does it matter?
  positionY = positionY + velocity * dt;
  if (right_direction) {
    positionX = positionX + x_speed / 2.0;
  } else {
    positionX = positionX - x_speed / 2.0;
  }
  
  velocity = velocity + acceleration * dt;  
  
  //Collision Code (update velocity if we hit the floor)
  if (positionY + radius > floor) {
    positionY = floor - radius;
    velocity *= -0.95;
  }
  
  // Collide with wall and bounce to the other side.
  if (x_speed > 2) {
    if (positionX + radius > 600) {
      right_direction = false;
      x_speed -= 2;
    } else if (positionX - radius < 0) {
      right_direction = true;
      x_speed -= 2;
    }
  } else {
    x_speed = 0;
  }
}


void drawScene() {
  background(255, 255, 255);
  fill(100,255,100);          // color with green
  lights();
  translate(positionX, positionY);
  sphere(radius);                 // sphere with radius 40.
}


// when mouse clicks.
void mouseClicked() {
  if (mouseX < 300) {
    right_direction = true;
    x_speed = 10;
  }
  else if (mouseX > 300) {
    right_direction = false;
    x_speed = 10;
  }
  
  velocity *= 1.10;
  if (mouseY > 300) {
    if (velocity > 0) {
      velocity *= -1.0;
    }
  } else if (mouseY < 300) {
    velocity *= 0.5;    
  }

}



void draw() {
  float startFrame = millis(); //Time how long various components are taking
  
  //Compute the physics update
  computePhysics(0.15); //Question: Should this be a fixed number?
  float endPhysics = millis();
  
  //Draw the scene
  drawScene();
  float endFrame = millis();
  
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  //print(runtimeReport);
}
