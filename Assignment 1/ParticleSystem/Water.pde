
color[] water = {color(12, 113, 195), color(46, 163, 242), color(182, 223, 233), color(220, 220, 200)};

ArrayList<Water> particles = new ArrayList<Water>();    // list of particles


class Water extends Particle {

  Water(vec3 position, vec3 velocity, color c_, float s_) {
    pos = position;
    vel = velocity;
    c = c_;
    s = s_;
  }

  void moveParticle(float dt) {
    pos.x += vel.x * dt + 2;
    pos.y += vel.y * dt;
    pos.z += vel.z * dt;
    vel.y += gravity * 0.3 * dt;    
    
    
    if (pos.distance(o.pos) < obstacleSize) {
      vec3 normal = pos.subtract(o.pos);
      normal.normalize();
      //normal.y = -normal.y;
      pos = (o.pos).addition(normal.multiply(obstacleSize * 1.05));
         
//      vNorm = velList[i].dot(normal)*normal 
//      velList[i] -= vNorm #stoping
//velList[i] -= .7*vNorm
      
      vec3 vNorm = (normal.multiply(vel.dot(normal)));
      vNorm.normalize();
      vel = vel.subtract(vNorm);
      vel = vel.subtract(vNorm.multiply(0.1));
      
    }
    if (pos.y > 180){
      //position = 180 - radius; //Robust collision check
      pos.y = 180 + 0.001;
      vel.x += random(-15,15);
      vel.y *= random(-.2, -1); //Coefficient of restitution (don't bounce back all the way) 
      vel.z += random(-15,15);
    } 
    s += dt;
  }

  boolean isDelete() {
    if (s > maxLife) {
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


void resetWater() {
  particles.clear();
}

vec3 randPosCircleWater(float r_) {
  float r, theta;
  float x = 0;
  float y = 0;
  float z = 0;


  r = r_ * sqrt(random(1)); 
  theta = TWO_PI * random(1);
  x = 0;
  y = r * sin(theta);
  z = r * cos(theta);

  return new vec3(x, y, z);
}


void spawnWater(float dt) {
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
    // generate particles
    pos = randPosCircleWater(radius);
    vel = new vec3(.1 * random(1), 1, .1 * random(1));
    col = water[int(random(4))];
    lifespan = 0.0;
    particles.add(new Water(pos, vel, col, lifespan));
  }
}


void removeWater() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Water p = particles.get(i);
    if (p.isDelete()) {
      numParticles -= 1;
      particles.remove(i);
    }
  }    
  //if (particles.size() == 1000) {
  //  particles.remove(0);
  //}
}








void WaterScene() {
  spawnWater(0.15);
  removeWater();

  for (Water a : particles) {
    a.moveParticle(0.15);
    a.display();
  }
}



void Human() {
  noStroke();
  // Head
  pushMatrix();
  translate(0, -15, 0);
  fill(color(255, 220, 177));
  sphere(35);
  popMatrix();

  pushMatrix();
  fill(color(255, 255, 255));
  translate(25, -20, -15);
  sphere(10);
  popMatrix();

  pushMatrix();
  translate(25, -20, 15);
  sphere(10);
  popMatrix();

  fill(color(0, 0, 0));
  pushMatrix();
  translate(32, -20, -15);
  sphere(4);
  popMatrix();

  pushMatrix();
  translate(32, -20, 15);
  sphere(4);
  popMatrix();
}

void Floor() {
  pushMatrix();
  translate(0, 180, 0);
  fill(155,155,155);
  rotateX(PI/2);
  rect(-500, -500, 1000, 1000);
  popMatrix();
  
}
