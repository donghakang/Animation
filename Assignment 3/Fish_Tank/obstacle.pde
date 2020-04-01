

int obstacles_num = 2;
Obstacles o = new Obstacles();
class Obstacle {
  vec3 pos;
  float size;
  float radius = 125;

  Obstacle() {
    pos  = new vec3(random(0, w), h, random(0, s));
    size = 30;

  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    shape(rock, 0, 0);
    popMatrix();
  }
}

class Obstacles {
  ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

  Obstacles() {
    for (int i = 0; i < obstacles_num; i ++) {
      Obstacle n = new Obstacle();
      obstacles.add(n);
    }
  }


  void display() {
    for (Obstacle o : obstacles) {
      o.display();
    }
  }
}
