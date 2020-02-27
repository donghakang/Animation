class Spring {
  vec3 pos = new vec3();
  vec3 vel = new vec3();
  vec3 force = new vec3();
  
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


// a - b
void ForceY(Spring a, Spring b, float dt) {
  vec3  e = new vec3(b.pos.x - a.pos.x, b.pos.y - a.pos.y, b.pos.z - a.pos.z);
  float l = e.dist();
  e       = e.divideBy(l);
  
  float v1 = dot(a.vel, e);
  float v2 = dot(b.vel, e);
  
  float springF = -k * (l - restLen);
  float dampF   = -kv * (v2 - v1);
  float F       = springF + dampF;
  
  float F_x     = F * e.x;
  float F_y     = F * e.y;
  float F_z     = F * e.z;
  
  a.vel.x -= F_x/mass * dt;
  a.vel.y -= F_y/mass * dt;
  a.vel.z -= F_z/mass * dt;
  
  
  b.vel.x += F_x/mass * dt;
  b.vel.y += F_y/mass * dt;
  b.vel.z += F_z/mass * dt; 
  
}


void ForceX(Spring a, Spring b, float dt) {
  vec3  e = new vec3(b.pos.x - a.pos.x, b.pos.y - a.pos.y, b.pos.z - a.pos.z);
  float l = e.dist();
  e       = e.divideBy(l);
  
  float v1 = dot(a.vel, e);
  float v2 = dot(b.vel, e);
  
  float springF = -k * (l - restLen);
  float dampF   = -kv * (v2 - v1);
  float F       = springF + dampF;
  
  float F_x     = F * e.x;
  float F_y     = F * e.y;
  float F_z     = F * e.z;
 
  a.vel.x -= F_x/mass * dt;
  a.vel.y -= F_y/mass * dt;
  a.vel.z -= F_z/mass * dt;
  
  
  b.vel.x += F_x/mass * dt;
  b.vel.y += F_y/mass * dt;
  b.vel.z += F_z/mass * dt; 
}
