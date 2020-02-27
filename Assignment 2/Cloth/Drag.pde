
float p  = 1.225;      // 1.225 kg/m3
float cd = 1.0;
vec3 v_air = new vec3(0, 0, 0);


void dragForce (Spring r1, Spring r2, Spring r3, Spring r4) {
  // p  = density of fluid
  // v  = velocity (relative to fluid)
  // v_air = velocity of air
  // a  = area
  // cd = drag coefficient (unitless)
  
  vec3 v = new vec3((r1.vel.x + r2.vel.x + r3.vel.x + r4.vel.x)/4.0, (r1.vel.y + r2.vel.y + r3.vel.y + r4.vel.z)/4.0, (r1.vel.z + r2.vel.z + r3.vel.z + r4.vel.z)/4.0);
  v      = v.subtract(v_air);

  vec3 n = cross((r2.pos).subtract((r1.pos)), (r3.pos).subtract((r1.pos))); 
  //println(2 * n.dist());
  float temp = v.dist() * dot(v, n);
  //println(temp);
  temp = temp / (2 * n.dist());
  
  vec3 van = n.multiplyBy(temp);
  float var = -.5 * p * cd;
  van = van.multiplyBy(var);

  r1.vel.x += van.x ;
  r1.vel.y += van.y ;
  r1.vel.z += van.z ;
  
  r2.vel.x += van.x ;
  r2.vel.y += van.y ;
  r2.vel.z += van.z ;
  
  r3.vel.x += van.x ;
  r3.vel.y += van.y ;
  r3.vel.z += van.z ;
  
  r4.vel.x += van.x ;
  r4.vel.y += van.y ;
  r4.vel.z += van.z ;
}
