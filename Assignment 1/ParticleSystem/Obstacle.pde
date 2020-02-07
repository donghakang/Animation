
float obstacleSize = 25;

class Obstacle {
  vec3 pos;
  
  Obstacle() {
    pos = new vec3(171, 97, -6); 
  }
  
  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    fill(color(255,0,0));
    sphere(obstacleSize);
    popMatrix();
  }
  
  void print() {
    println("(" + str(pos.x) + ", " + str(pos.y) + ", " + str(pos.z) + ")");
  }
  
  void controller() {
    if (mousePressed) {
      if (mouseY < 300) {
        pos.y = mouseY - 150;
      }
    }
    if (keyPressed && keyCode == UP) {
      pos.z -= 3;
    }
    if (keyPressed && keyCode == DOWN) {
      pos.z += 3;
    }
    if (keyPressed && keyCode == RIGHT) {
      pos.x += 3;
    } 
    if (keyPressed && keyCode == LEFT) {
      pos.x -= 3;
    }
  }
}

void Obstacle() {
  o.controller();
  o.display();
}
