
color[] Fire = {color(255, 0, 0), color(255, 90, 0), color(255, 154, 0), color(255, 232, 8)};
color[] smok = {color(200, 200,200, 50), color(240,240,240,50), color(100, 100, 100,50), color(50,50,50,50)};

Boolean smokeTrigger = false;

ArrayList<Fire> fires = new ArrayList<Fire>();    // list of fires
ArrayList<Fire> sparks = new ArrayList<Fire>();

ArrayList<Smoke> smoke = new ArrayList<Smoke>();

class Smoke extends Particle {

  Smoke(vec3 position, vec3 velocity, color c_, float s_) {
    pos = position;
    vel = velocity;
    c = c_;
    s = s_;
  }
  
  void moveParticle(float dt) {
    pos = pos.addition(vel.multiply(dt)); 
    vel = vel.addition(new vec3(random(-.2,.2), 0, random(-.2,.2)));
    s += dt;
  }
  
  boolean isDelete() {
    if (s > maxFire + 10) {
      return true;
    } else {
      return false;
    }
  }
  
  void display() {
    pushMatrix();
    fill(c);
    translate(pos.x, pos.y, pos.z);
    sphere(10);
    popMatrix();
  }
}




class Fire extends Particle {

  Fire(vec3 position, vec3 velocity, color c_, float s_) {
    pos = position;
    vel = velocity;
    c = c_;
    s = s_;
  }

  void moveParticle(float dt) {
    //println(pos.x);
    if (s > 10) {
      if (pos.x < 0) {
        if (pos.x < -8) {
          s += 0.05;
        }
        if (pos.x < -13) {
          s += 0.1;
        }
        if (pos.x < -18) {
          s += 0.1;
        } 
      } else {
        if (pos.x > 8) {
          s += 0.05;
        }
        if (pos.x > 13) {
          s += 0.1;
        }
        if (pos.x > 18) {
          s += 0.2;
        }
      }
      
      if (pos.z < 0) {
        if (pos.z < -8) {
          s += 0.05;
        }
        if (pos.z < -13) {
          s += 0.1;
        }
        if (pos.z < -18) {
          s += 0.1;
        } 
      } else {
        if (pos.z > 8) {
          s += 0.05;
        }
        if (pos.z > 13) {
          s += 0.1;
        }
        if (pos.z > 18) {
          s += 0.2;
        }
      }
      
      pos.x += vel.x * dt + random(-0.5, 0.5);
      pos.y += vel.y * dt;
      pos.z += vel.z * dt;
    } else {
      pos.x += vel.x * dt;
      pos.y += vel.y * dt;
      pos.z += vel.z * dt;
      //vel.y += gravity * -0.1 * dt;
      
    } 
    
    s += dt;
  }

  boolean isDelete() {
    if (s > maxFire) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    pushMatrix();
    stroke(c);
    //line(pos.x, pos.y, pos.z, pos.x + 1, pos.y + vel.y, pos.z);
    point(pos.x, pos.y, pos.z);
    popMatrix();
  }
}



void resetFire() {
  //ArrayList<Fire> fires = new ArrayList<Fire>();
  //ArrayList<Fire> sparks = new ArrayList<Fire>();
  //ArrayList<Smoke> smoke = new ArrayList<Smoke>();
  fires.clear();
  sparks.clear();
  smoke.clear();
}

vec3 randPosCircleFire(float r_) {
  float r, theta;
  float x = 0;
  float y = 0;
  float z = 0;


  r = r_ * sqrt(random(10)); 
  theta = TWO_PI * random(1);
  x = r * sin(theta);
  y = 0;
  //y = -sqrt(pow(r,2) - pow(x,2) - pow(z,2));
  z = r * cos(theta);

  return new vec3(x, y, z);
}


void spawnFire(float dt) {
  numParticles = int(dt * genRate);
  if (random(1) < dt * genRate) {
    numParticles += 1;
  }
  vec3 pos, vel;
  color col;
  float lifespan;

  //numParticles += 1;
  //print(numParticles);
  for (int i = 0; i < numParticles; i ++) {
    // generate fires
    pos = randPosCircleFire(radius);
    vel = new vec3(.5 * random(1), -5, .5 * random(1));
    col = Fire[int(random(4))];
    lifespan = random(10);
    fires.add(new Fire(pos, vel, col, lifespan));
  }
}

void spawnSpark(float dt) {
  float genRateSpark = genRate - 15;
  numParticles = int(dt * genRateSpark);
  if (random(1) < dt * genRateSpark) {
    numParticles += 1;
  }
  vec3 pos, vel;
  color col;
  float lifespan;

  //numParticles += 1;
  //print(numParticles);
  for (int i = 0; i < numParticles; i ++) {
    // generate fires
    pos = randPosCircleFire(5);
    vel = new vec3(.5 * random(1), -5, .5 * random(1));
    col = color(255,255,0);
    lifespan = random(10,20);
    sparks.add(new Fire(pos, vel, col, lifespan));
  }
}

void spawnSmoke(float dt) {
  //float genRateSmoke = genRate - 20;
  //numParticles = int(dt * genRateSmoke);
  numParticles = 1;
  //if (random(1) < dt * genRateSmoke) {
  //  numParticles += 1;
  //}
  vec3 pos, vel;
  color col;
  float lifespan;

  //numParticles += 1;
  //print(numParticles);
  for (int i = 0; i < numParticles; i ++) {
    // generate fires
    pos = randPosCircleFire(5);
    pos.y = pos.y - 100;
    vel = new vec3(.5 * random(1), -5, .5 * random(1));
    col = smok[int(random(4))];
    lifespan = random(10,20);
    smoke.add(new Smoke(pos, vel, col, lifespan));
  }
}


void removeFire() {
  for (int i = fires.size() - 1; i >= 0; i--) {
    Fire p = fires.get(i);
    if (p.isDelete()) {
      smokeTrigger = true;
      numParticles -= 1;
      fires.remove(i);
    }
  }
}

void removeSpark() {
  for (int i = sparks.size() - 1; i >= 0; i--) {
    Fire p = sparks.get(i);
    if (p.isDelete()) {
      numParticles -= 1;
      sparks.remove(i);
    }
  }
}

void removeSmoke() {
  for (int i = smoke.size() - 1; i >= 0; i--) {
    Smoke p = smoke.get(i);
    if (p.isDelete()) {
      numParticles -= 1;
      smoke.remove(i);
    }
  }
}



void FireScene() {
  spawnFire(0.5);
  removeFire();
  spawnSpark(0.5);
  removeSpark();
  if (smokeTrigger == true) {
    spawnSmoke(0.5);
    removeSmoke();
  }
  
  for (Smoke s : smoke) {
    s.moveParticle(0.2);
    s.display();
  }
  for (Fire a : fires) {
    a.moveParticle(0.2);
    a.display();
  }
  for (Fire b : sparks) {
    b.moveParticle(0.2);
    b.display();
  }
}


void Log() {
  pushMatrix();
  translate(0, 5, 0); 
  fill(133, 94, 66);
  noStroke();
  box(10, 10, 100);
  box(100, 10, 10);
  popMatrix();
  
  pushMatrix();
  rotateY(PI/4);
  rotateX(PI/30);
  fill(133, 94, 66);
  box(10, 10, 100);
  //box(100, 10, 10);
  popMatrix();
  
  pushMatrix();
  rotateY(PI/4);
  rotateZ(PI/30);
  fill(133, 94, 66);
  box(100, 10, 10);
  popMatrix();
}
