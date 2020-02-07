// VARIABLE
float camX = 300;
float camY = 400;
float camZ = 200;
Boolean translation = false;
float ang = PI/60;
float save_ang = 0;


void fireCamera() {
  if (keyPressed && keyCode == UP && translation) {
    camY -= 1;
    beginCamera();
    camera();
    translate(camX, camY, camZ);
    endCamera();  
  }
  else if (keyPressed && keyCode == DOWN && translation) {
    camY += 1;
    beginCamera();
    camera();
    translate(camX, camY, camZ);
    endCamera(); 
  }
  else if (keyPressed && keyCode == RIGHT && translation) {
    camX += 1;
    beginCamera();
    camera();
    translate(camX, camY, camZ);
    endCamera(); 
  }
  else if (keyPressed && keyCode == LEFT && translation) {
    camX -= 1;
    beginCamera();
    camera();
    translate(camX, camY, camZ);
    endCamera(); 
  }
  else if (keyPressed && keyCode == UP) {
    camZ += 10;
    beginCamera();
    camera();
    translate(camX, camY, camZ);
    endCamera();  
  }
  else if (keyPressed && keyCode == DOWN) {
    camZ -= 10;
    beginCamera();
    camera();
    translate(camX, camY, camZ);
    endCamera(); 
  }
  else if (keyPressed && keyCode == RIGHT) {
    beginCamera();
    rotateY(-ang);
    save_ang -= ang;
    endCamera(); 
  }
  else if (keyPressed && keyCode == LEFT) {
    beginCamera();
    rotateY(ang);
    save_ang += ang;
    endCamera(); 
  }
}
