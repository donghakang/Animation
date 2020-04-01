
ArrayList<Boid> boids = new ArrayList<Boid>();    // list of fires

class Boid {
  vec2  pos   = new vec2();
  vec2  vel   = new vec2();
  vec2  acc   = new vec2();
  int   boid_num;
  float max_speed;
  float size;
  float detect_r;

  Boid(float x, float y) {
    pos.set(x, y);
    vel.set(random(-3,3), random(-3,3));
    acc.set(0, 0);

    boid_num  = boids.size();
    max_speed = 3;
    size      = 10;
    detect_r  = 200;
  }

  // update position of the boid
  void edge_detect() {
    pos = add(pos, vel);
    vel = add(vel, acc);
    if (pos.x > w) pos.x = 0;
    if (pos.x < 0) pos.x = w;
    if (pos.y > h) pos.y = 0;
    if (pos.y < 0) pos.y = w;
  }



  void display() {
    pushMatrix();
    noStroke();
    fill(color(255,0,0));
    circle(pos.x, pos.y, size);
    popMatrix();
  }

  void display_detect() {
    pushMatrix();
    noStroke();
    fill(color(255,255,0));
    circle(pos.x, pos.y, size);
    popMatrix();
  }

  void display_main() {
    pushMatrix();
    noStroke();
    fill(color(0,0,0,50));
    circle(pos.x, pos.y, detect_r);
    fill(color(0,255,0));
    circle(pos.x, pos.y, size);
    popMatrix();
  }
}


void range_detect() {
  Boid base = boids.get(0);
  for (Boid b : boids) {
    if (b.boid_num != 0) {
      if (dist(b.pos, base.pos) < base.detect_r / 2.0) {
        b.display_detect();
      }
    }
  }
}

// a is the base.
boolean inRange(Boid a, Boid b) {
  return dist(b.pos, a.pos) < a.detect_r / 2.0;
}


// BOIDS
vec2 calculate_boid(Boid base) {
  vec2 cohesion   = new vec2();
  vec2 alignment  = new vec2();
  vec2 separation = new vec2();
  vec2 final_vel  = new vec2();

  for (Boid b : boids) {
    // base case
    if (b.boid_num != base.boid_num) {
      // inside the range
      cohesion = add(cohesion, b.pos);    // cohesion
      alignment  = add(alignment, b.vel);
      if (inRange(base, b)) {
        vec2 temp = subtract(b.pos, base.pos);
        separation = subtract(separation, temp);
      }
    }
  }
  cohesion = divide(cohesion, boids.size()-1);
  cohesion = subtract(cohesion, base.pos);
  cohesion = divide(cohesion, 100);

  alignment = divide(alignment, boids.size()-1);
  alignment = subtract(cohesion, base.vel);
  alignment = divide(alignment, 8);

  separation = divide(separation, 100);
  separation.print();

  final_vel.x = cohesion.x + alignment.x + separation.x;
  final_vel.y = cohesion.y + alignment.y + separation.y;

  return final_vel;
}

void update() {
  // for (int i = 0; i < boids.size(); i++) {
    Boid base = boids.get(0);
    vec2 final_vel = calculate_boid(base);

    base.vel = add(base.vel, final_vel);
    if (base.vel.dist() > base.max_speed) {
      base.vel = multiply(divide(base.vel, base.vel.dist()), base.max_speed);
    }
    base.pos = add(base.pos, base.vel);

}
