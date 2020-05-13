


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
  
 

  
  void update() {
    //println(vertices.get(0).v);
    int current = 0;
    int size = vertices.size();
    float sp = 0;
    
    if (speed_status == 1) {
      sp = 1;
    }
    if (speed_status == 2) {
      sp = 2;
    }
    if (speed_status == 3) {
      sp = 3;
    }
    if (speed_status == 4) {
      sp = 4;
    }
    sp *= magnitude;
    
    
    for (Edge edges : vertices) {
      if (edges.v) {
          drawing(edges.n1.pos.x, edges.n1.pos.y, edges.n2.pos.x, edges.n2.pos.y); 
      }
    }

    for (int i = vertices.size() - 1; i >= 0; i-- ) {
      if (!vertices.get(i).v) {
        current = i;
      }
    }
    
    
    Edge e = vertices.get(current);
    
    if (!e.v) {
      float slopeX = e.n2.pos.x - e.n1.pos.x;
      float slopeY = e.n2.pos.y - e.n1.pos.y;
      
      float X = slopeX * dt * sp;
      float Y = slopeY * dt * sp;
      
      vec2 lerp = new vec2( X + e.n1.pos.x, Y + e.n1.pos.y);
      
      if (dt*sp > 1) {
        drawing(e.n1.pos.x, e.n1.pos.y, e.n2.pos.x, e.n2.pos.y);

        e.v = true;
        dt  = 0;
      }
      else {
        drawing(e.n1.pos.x, e.n1.pos.y, lerp.x, lerp.y);
      }
    }
    
    // top light follows the cloud
    vertices.get(0).n1.pos.x = main_cloud.x + 25;
    
    // move along with the speed
    for (int j = 0; j < size; j ++ ){
      vertices.get(j).n1.pos.x += main_cloud.speed * (size - j) / size;
      vertices.get(j).n2.pos.x += main_cloud.speed * (size - j) / size;
    }

    // if it goes in two different way, divide the speed.
    for (int count1 = 0; count1 < size; count1 ++) {
      for (int count2 = count1 + 1; count2 < size; count2 ++) {
        Node N1 = vertices.get(count1).n1;
        Node N2 = vertices.get(count2).n1;
        if ((N1.pos.x == N2.pos.x) && (N1.pos.y == N2.pos.y)) {
          vertices.get(count1).n1.pos.x -= main_cloud.speed * (size - count2) / size;
        }
      }
    }
      
    
  }
  
  
  
  void reset() {
    for (Edge e : vertices) {
      e.v = false;
    }
  }
}



void magnitude_setup() {
  switch(magnitude) {
  case 0:
    l_dis = 20; 
    l_len = 100;
    break;
  case 1: 
    l_dis = 40; 
    l_len = 50;
    break;
  case 2:
    l_dis = 50; 
    l_len = 20;
    break;
  case 3:
    l_dis = 70; 
    l_len = 15;
    break;
  case 4:
    l_dis = 100; 
    l_len = 10;
    break;
  case 5:
    l_dis = 200; 
    l_len = 5;
    break;
  }
  
}




void drawing(float x1, float y1, float x2, float y2) {
  pushMatrix();
  for (int i = 16; i > 10; i -= 2) {
    //smooth();
    strokeWeight(i);
    stroke(color(255,255,0,15));
    line(x1,y1,x2,y2);
  }
  popMatrix();
  pushMatrix();
  strokeWeight(1);
  stroke(color(255,255,255));
  line(x1,y1,x2,y2);
  popMatrix();
}



// change the speed of the environment.
// speed : 1x, 0.5x, 0.25x, 0.01x
void lightning_display_speed(int status) {
  // Change of the cloud speed.
  speed_status = status;
  float speed  = cloud_speed;
  if (status == 1) {
    speed = 0.01;
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
  l.update();
}
