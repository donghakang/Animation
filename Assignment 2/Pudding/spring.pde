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



void Force(Spring a, Spring b, float dt) {
  vec3  e = new vec3(b.pos.x - a.pos.x, b.pos.y - a.pos.y, b.pos.z - a.pos.z);
  float l = e.dist();
  e       = e.divideBy(l);
  
  float v1 = dot(a.vel, e);
  float v2 = dot(b.vel, e);
  
  float springF = -k * (l-restLen);
  float dampF   = -kv * (v2 - v1);
  float F       = springF + dampF;
  
  float F_x     = F * e.x;
  float F_z     = F * e.z;
  
  a.vel.x -= (F_x/mass) * dt;
  a.vel.z -= (F_z/mass) * dt;
  
  b.vel.x += (F_x/mass) * dt;
  b.vel.z += (F_z/mass) * dt; 
}



void Force_Normal(float dt) {

  // Only Applying x axis. 
  for (int i = 0; i < numHeight-1; i ++) {
    for (int j = 0; j < numPoints; j ++) {
       Force(pudding[i][j], pudding[i+1][j], dt);
    }
  }
  
  for (int i = 0; i < numHeight; i++ ) {
    Force(pudding[i][numPoints - 1], pudding[i][0], dt);
  }
  
  // eventually stops.
  if (abs(pudding[0][10].vel.x) < 0.02 && abs(pudding[0][10].vel.z) < 0.02) {
    for (int i = 0; i < numHeight; i ++) {
      for (int j = 0; j < numPoints; j ++) {
        pudding[i][j].vel.x = 0;
        pudding[i][j].vel.z = 0;
      }
    }
  }
  
}
