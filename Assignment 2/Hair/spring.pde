float floor = 400;
float grav = 1300; //0
float anchorX = 200;
float anchorY = 50;
float restLen = 10;
float mass = 3;
float k = 500; //1 1000
float kv = 100;

int numX = 1500;
int numY = 8;

int count = 0;
Spring[][] springs = new Spring[numX][numY];

class Spring {
  vec3 pos = new vec3();
  vec3 vel = new vec3();
  
  Spring(float p_x, float p_y, float p_z) {
    pos.x = p_x;
    pos.y = p_y;
    pos.z = p_z;
    vel.x = 0;
    vel.y = 0;
    vel.z = 0;
  }
  
  void updatePos(float dt) {
    pos.x += vel.x * dt;
    pos.y += vel.y * dt;
    pos.z += vel.z * dt;
  }
}


// for initialization
vec3 randomPositionGenerator() {
  vec3 returnVector = new vec3();
  float r = radius * sqrt(random(1));
  float theta = random(TWO_PI * 10);
  float x = r * sin(theta);
  float z = r * cos(theta);
  returnVector.x = x;
  returnVector.z = z;
  returnVector.y = lerp(-75, -50, sqrt(x*x + z*z)/radius);

  return returnVector;
}



void init() {
  vec3 v = new vec3();
  for (int i = 0; i < numX; i ++) {
    for (int j = 0; j < numY; j ++) {
      //springs.get(j).add(new Spring(200,50 + 5*i, 0));
      v = randomPositionGenerator();
      springs[i][j] = new Spring(v.x, v.y, v.z);
    }
  }
}



void Force(Spring a, Spring b, float dt) {
  vec3  e = new vec3(b.pos.x - a.pos.x, b.pos.y - a.pos.y, b.pos.z - a.pos.z);
  float l = e.dist();
  e       = e.divideBy(l);
  
  float v1 = dot(a.vel, e);
  float v2 = dot(b.vel, e);
  
  float springF = -k * (l - random(restLen));
  float dampF   = -kv * (v2 - v1);
  float F       = springF + dampF;
  
  float F_x     = F * e.x;
  float F_y     = F * e.y;
  float F_z     = F * e.z;
  
  
  a.vel.x -= 2 * (F_x/mass) * dt;
  a.vel.y -= (F_y/mass) * dt;
  a.vel.z -= 2 * (F_z/mass) * dt;
  
  b.vel.x += 2 * (F_x/mass) * dt;
  b.vel.y += (F_y/mass) * dt;
  b.vel.z += 2 * (F_z/mass) * dt; 
}





// return if the line hits the other
// algorithm from stack overflow. and youtube.
float lineCollision(Spring a, Spring b, Spring c, Spring d) {
  vec3 r = b.pos.subtract(a.pos);
  vec3 s = d.pos.subtract(c.pos);
  vec3 q = a.pos.subtract(c.pos);
  
  float qr = dot(q, r);
  float qs = dot(q, s);
  float rs = dot(r, s);
  float rr = dot(r, r);
  float ss = dot(s, s);
  
  float denominator = rr * ss - rs * rs;
  float numerator   = qs * rs - qr * ss;
  float t = numerator / denominator;
  float u = (qs + t * rs) / ss;
  
  vec3 p0 = a.pos.addition(r.multiplyBy(t));
  vec3 p1 = c.pos.addition(s.multiplyBy(u));
  
  if (0 <= t && t <= 1 && 0 <= u && u <= 1) return (p1.subtract(p0)).dist();
  if ((p1.subtract(p0)).dist() <= 0.01) return (p1.subtract(p0)).dist();
  
  return 0;
}






void ForceCombined(float dt) {
  // Force Y.
  for (int i = 0; i < numX; i ++) {
    for (int j = 0; j < numY -1; j ++) {
       Force(springs[i][j], springs[i][j+1], dt);
    }
  }
  
  // Gravitational Force
  for (int i = 0; i < numX; i ++) {
    for (int j = 0; j < numY; j ++) {
       springs[i][j].vel.y += grav * dt;
    }
  }
  
  // Air Velocity
  if (airOn) {
    for (int i = 0; i < numX; i ++) {
      for (int j = 0; j < numY; j ++) {
         springs[i][j].vel.x += 800.0 * dt;
         springs[i][j].vel.z -= 800.0 * dt;
      }
    }
  }
  
  // Hair Collision handler
  for (int i = 0; i < numX -1; i ++ ) {
    for (int j = 0; j < numY -1; j++) {
      // hair collision
      if (lineCollision(springs[i][j], springs[i][j+1], springs[i+1][j], springs[i+1][j+1]) != 0) {
        // bounce to other direction when it is colliding.
        springs[i][j].vel.x *= -0.06;
        springs[i][j].vel.z *= -0.06;
        
        springs[i+1][j].vel.x *= -0.06;
        springs[i+1][j].vel.z *= -0.06;
        
      }
    }
  }

  
 
  // collision Head
  for (int i = 0; i < numX; i ++) {
    for (int j = 0; j < numY; j ++) {
      float x = springs[i][j].pos.x;
      float y = springs[i][j].pos.y;
      float z = springs[i][j].pos.z;
      
      vec3 d = new vec3( x, y - sphereY, z);
      if (d.dist() < radius + 0.09) {
        vec3 n = new vec3( -1 * ( -x), -1 * (sphereY - y), -1 * ( -z));    // surface normal 
        n.normalize();
        // bounce = np.multiply(np.dot(v[i,j],n),n)
        float dott = dot(springs[i][j].vel, n);
        vec3 bounce = n.multiplyBy(dott);
        springs[i][j].vel.x -= 1.5 * bounce.x;
        springs[i][j].vel.y -= 1.5 * bounce.y;
        springs[i][j].vel.z -= 1.5 * bounce.z;
        
        springs[i][j].pos.x += (2 + radius - d.dist()) * n.x;
        springs[i][j].pos.y += (2 + radius - d.dist()) * n.y;
        springs[i][j].pos.z += (2 + radius - d.dist()) * n.z;
        // v[i,j] -= 1.5*bounce
        // p[i,j] += np.multiply(.1 + sphereR - d, n) #move out
      }
    }
  }
  
  // Top Hair does not move
  for (int i = 0; i < numX; i++) {
    springs[i][0].vel.x = 0;
    springs[i][0].vel.y = 0;
    springs[i][0].vel.z = 0;
  }
}
