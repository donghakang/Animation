


class Lightning {
  ArrayList<Edge> vertices;
  float speed;     // 0.1, 0.25, 0.5, 1.
  
  Lightning() {
    vertices = E;
  }
  
  void display() {
    // Yellow Glow
    pushMatrix();
    for (Edge e : vertices) {
      for (int i = 16; i > 10; i -= 2) {
        //smooth();
        strokeWeight(i);
        stroke(color(255,255,0,15));
        line(e.n1.pos.x, e.n1.pos.y, e.n2.pos.x, e.n2.pos.y);
      }
    }
    popMatrix();
    
    // White Strike
    pushMatrix();
    for (Edge e : vertices) {
      strokeWeight(1);
      stroke(color(255,255,255));
      line(e.n1.pos.x, e.n1.pos.y, e.n2.pos.x, e.n2.pos.y);
    }
    popMatrix();
  }
  
  void display_first() {
    vertices.get(0).display();
  }
  
  void update(float speed) {
    
    
  }
}


// Lightning Display
void lightning_display() {
  pushMatrix();
  
  for (Edge e : E) {
    for (int i = 20; i > 10; i -= 2) {
      strokeWeight(i);
      stroke(color(255,255,0,10));
      line(e.n1.pos.x, e.n1.pos.y, e.n2.pos.x, e.n2.pos.y);
    }
  }
  popMatrix();
}

// change the speed of the environment.
// speed : 1x, 0.5x, 0.25x, 0.01x
void lightning_display_speed(int status) {
  // Change of the cloud speed.
  speed_status = status;
  float speed  = cloud_speed;
  if (status == 1) {
    speed = 0.1;
  } 
  else if (status == 2) {
    speed = 0.25;
  }
  else if (status == 3) {
    speed = 0.5;
  } 
  else if (status == 4) {
    speed = 1;
  }
  
  for (Cloud cloud : env_cloud) {
    cloud.speed = random(speed/2, speed);
  }
  main_cloud.speed = random(speed/2, speed);
  cloud_speed = random(speed/2, speed);
  
  
  // Change of the Thunder speed
}
