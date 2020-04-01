
ArrayList<Boid> boids = new ArrayList<Boid>();


class Boid {
  vec2 pos;
  vec2 vel;
  vec2 acc;
  float r;
  float neighbor;
  float max_speed;
  float max_force;
  int   boid_num;
  int   c = int(random(100,200));

  float separation_force = 1.5;
  float alignment_force  = 1;
  float cohension_force  = 1.3;

  Boid (float x, float y) {
    pos = new vec2(x, y);
    vel = new vec2(random(-1,1), random(-1,1));
    acc = new vec2();
    r   = 5.0;
    neighbor  = 100.0;

    max_speed = 5.0;
    max_force = 0.05;

    boid_num = boids.size();
  }




  void boid() {
    update();
    out();
    compute_boid();
    display();
  }


  void out() {
    if (pos.x > w) pos.x = 1;
    if (pos.x < 0) pos.x = w-1;
    if (pos.y > h) pos.y = 1;
    if (pos.y < 0) pos.y = h-1;
  }

  void update() {
    vel = add(vel, acc);
    // if (vel.dist() > max_speed) {
    //   vel = multiply(divide(vel, vel.dist()), max_speed);
    // }
    pos = add(pos, vel);
    acc.set(0,0);
  }


  void display() {
    // fill(200, 100);
    pushMatrix();
    noStroke();
    circle(pos.x, pos.y, r);
    fill(color(255,c,0));
    popMatrix();
  }


  void compute_boid() {
    vec2 sep = separation();
    vec2 ali = alignment();
    vec2 coh = cohesion();


    vec2 c   = new vec2();
    c.x = separation_force * sep.x +
          alignment_force  * ali.x +
          cohension_force  * coh.x;
    c.y = separation_force * sep.y +
          alignment_force  * ali.y +
          cohension_force  * coh.y;


    acc = add(acc, c);
    // vel.normalize();
  }


  vec2 separation() {
    vec2 sep = new vec2();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor/2.0) {
          vec2 diff = subtract(pos, b.pos);
          diff.normalize();
          divide(diff, distance);
          sep = add(sep, diff);
          count+=1;
        }
      }
    }
    // if there is no neighbors.
    if (count == 0) {
      return sep;
    }
    else {
      // sep = multiply(sep, -1);
      sep = divide(sep, float(count));
    }
    if (sep.dist() > 0) {
      sep.normalize(max_speed);
      sep = subtract(sep, vel);
      sep.normalize(max_force);
    }

    return sep;
  }



  vec2 alignment() {
    vec2 ali = new vec2();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor) {
          ali = add(ali, b.vel);
          count += 1;
        }
      }
    }
    // if there is no neighbors.
    if (count == 0) {
      return ali;
    }
    else {
      ali = divide(ali, float(count));
      ali.normalize(max_speed);
      ali = subtract(ali, vel);
      ali.normalize(max_force);
      return ali;
    }
  }



  vec2 cohesion() {
    vec2 coh = new vec2();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor) {
          coh = add(coh, b.pos);
          count += 1;
        }
      }
    }
    // if there is no neighbors.
    if (count == 0) {
      return coh;
    }
    else {
      coh = divide(coh, float(count));
      coh = subtract(coh, pos);
      coh.normalize(max_speed);
      coh = subtract(coh, vel);
      coh.normalize(max_force);
      return coh;
    }
  }
}
