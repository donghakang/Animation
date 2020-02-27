// This might be really scary... just saying
// Dongha Kang

PShape s;

float rotateY = 0;
float sphereY = -30;
float radius = 70;

// boolean
boolean collisionOn = false;
boolean airOn = false;



void keyPressed() {
  if (keyCode == 'R') {
    init();
  }
  if (keyCode == 'A') {
    airOn = !airOn;
  }
  if (keyCode == '1') {
    collisionOn = !collisionOn;
  }
}



void setup() {
  size(600, 600, P3D);
  s = loadShape("data/Arnold.obj");
  s.translate(0,0,.03);
  s.rotate(PI, -0.2, 0.0, 1.0);
  s.scale(100);
  init();
}




void update(float dt){
  ForceCombined(dt);
  for (int i = 0; i < numX; i ++) {
    for (int j = 0; j < numY; j ++) {
      springs[i][j].updatePos(dt);
    }
  }
}  
  
  
void draw() { 
  count += 1;
  if (count % 70 == 0|| count % 51 == 0) {
  //if (false) {
    background(0,0,0);
  } else if (count % 12 == 0) {
    background(255,255,255); 
  } else {     
    background(70);
    if (count % 11 == 0) {
      pointLight(255,0,0,0, 10, 10);
    } 
    else {
      pointLight(100,100,100,0,10,10);
    }
    translate(width/2, height/2);
  
    if (keyPressed) {
      if (keyCode == LEFT) {
        s.rotateY(-0.05);
        rotateY -= 0.05;
      }
      if (keyCode == RIGHT) {
        s.rotateY(0.05);
        rotateY += 0.05;
      }
      if (keyCode == UP) {
        sphereY -= 1;
      }
      if (keyCode == DOWN) {
        sphereY += 1;
      }
    }
    
    for (int i = 0; i < 10; i++){
      update(1/(10*frameRate));
    }
    
    //HEAD
    pushMatrix();
    shininess(20.0);
    s.setFill(color(255,255,255));
    shape(s, 0, 0);
    popMatrix();
    
    // HAIR
    for (int i = 0; i < numX - 1; i++) {
      for (int j = 0; j < numY - 1; j++) {
        //stroke(random(255),random(255),random(255));
        pushMatrix();
        if (collisionOn && lineCollision(springs[i][j], springs[i][j+1], springs[i+1][j], springs[i+1][j+1]) != 0) stroke(255,0,0);
        else stroke(0,0,0);
        rotateY(rotateY);
        line(springs[i][j].pos.x, springs[i][j].pos.y, springs[i][j].pos.z, springs[i][j+1].pos.x, springs[i][j+1].pos.y, springs[i][j+1].pos.z);
        popMatrix();
      }
    }
  }
}
