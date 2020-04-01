
ArrayList<Boid> boids = new ArrayList<Boid>();


class Boid {
  vec3 pos;
  vec3 vel;
  vec3 acc;
  float r;
  float neighbor;
  float max_speed;
  float max_force;
  int   boid_num;

  float separation_force = 4;
  float alignment_force  = 3;
  float cohension_force  = 3;

  Boid (float x, float y, float z) {
    pos = new vec3(x, random(0,300), z);
    vel = new vec3(random(-2, 0), random(-1,1), random(-1,1));
    acc = new vec3(-1,0,0);
    r   = 5.0;
    neighbor  = 100.0;

    max_speed = 3.0;
    max_force = 0.1;

    boid_num = boids.size();
  }

  void boid() {
    acc.set(0,0,0);
    
    out();
    //acc.set(acc.x-1,acc.y,acc.z);
    compute_obstacle();
    compute_boid();
    //if (vel.dist() > max_speed) {
    vel.normalize(max_speed);
    update();
    display();
  }


  void out() {
     if (pos.x > w) pos.x = 1;
     if (pos.x < 0) pos.x = w-1;
     if (pos.y > h - 10) vel.y = -2 * vel.y;
     if (pos.y < 10)     vel.y = -2 * vel.y;
     if (pos.z > s - 3) {
       pos.z -= 0.01;
       vel.z = -2 * vel.z;
     }
     if (pos.z < 3) {
       pos.z += 0.01;
       vel.z = -2 * vel.z;
     }
  }

  void update() {
    vel = add(vel, acc);
    
    acc.y = 0;
    vel.y = 0;
    pos = add(pos, vel);
  }


  void display() {
    // fill(200, 100);
    float n = vel.rotate_to_direction();
    
    pushMatrix();
    // shininess(20.0);
    translate(pos.x, pos.y, pos.z);
    if (vel.x < 0 ) rotateY(-n);
    else            rotateY(PI - n);
    rotateX(PI/2);
    shape(fish, 0, 0);

    popMatrix();
  }

  void compute_obstacle(){
    vec3 separate = obstacle_separation(o);
    separate = multiply(separate, separation_force*5);
    acc = add(acc,separate);
    vel = add(vel, acc);

    pos = add(pos, vel);
  }

  vec3 obstacle_separation(Obstacles obs) {
    vec3 sep = new vec3();
    int count = 0;
    for (Obstacle o : obs.obstacles) {
      // separation force
      vec2 pos_xz = new vec2(pos.x, pos.z);
      vec2 o_pos_xz = new vec2(o.pos.x, o.pos.z);
      float distance = dist(pos_xz, o_pos_xz);
      if (distance < o.radius + 30) {
        vec2 diff = subtract(pos_xz, o_pos_xz);
        diff.normalize();
        divide(diff, dist(pos, o.pos));
        //sep = add(sep, diff);
        sep.x = sep.x + diff.x;
        sep.z = sep.z + diff.y;
        count += 1;
      }
    }
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


  void compute_boid() {
    vec3 sep = separation();
    vec3 ali = alignment();
    vec3 coh = cohesion();


    vec3 c   = new vec3();
    c.x = separation_force * sep.x +
          alignment_force  * ali.x +
          cohension_force  * coh.x;
    c.y = separation_force * sep.y +
          alignment_force  * ali.y +
          cohension_force  * coh.y;
    c.z = separation_force * sep.z +
          alignment_force  * ali.z +
          cohension_force  * coh.z;

    acc = add(acc, c);
    // vel.normalize();
    //vel.x += 1;
  }


  vec3 separation() {
    vec3 sep = new vec3();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor/2.0) {
          vec3 diff = subtract(pos, b.pos);
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



  vec3 alignment() {
    vec3 ali = new vec3();
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



  vec3 cohesion() {
    vec3 coh = new vec3();
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
