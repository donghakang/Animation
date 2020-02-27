
class vec3 {
  float x, y, z;
  
  // Constructor
  vec3() {
    x = 0.0;
    y = 1.0;
    z = 0.0;
  }
  
  vec3 (float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
  }
  
  
  vec3 addition(vec3 v) {
    vec3 vec = new vec3();
    vec.x = x + v.x;
    vec.y = y + v.y;
    vec.z = z + v.z;
    
    return vec;
  }
  
  vec3 subtract(vec3 v) {
    vec3 vec = new vec3();
    vec.x = x - v.x;
    vec.y = y - v.y;
    vec.z = z - v.z;
    
    return vec;
  }
  
  vec3 multiplyBy(float a) {
    vec3 vec = new vec3();
    vec.x = x * a;
    vec.y = y * a;
    vec.z = z * a;
    return vec;
  }
  
  vec3 divideBy(float a) {
    vec3 vec = new vec3();
    vec.x = x/a;
    vec.y = y/a;
    vec.z = z/a;
    return vec;
  }
  
  
  
  float dist() {
    return sqrt(x*x + y*y + z*z);
  }
  
  void normalize() {
    float division = sqrt(pow(x,2) + pow(y,2) + pow(z,2));
    x = x / division;
    y = y / division;
    z = z / division;
  }
  
  void print() {
    println("(" + str(x) + ", " + str(y) + ", " + str(z) + ")");
  }
}


vec3 cross (vec3 v1, vec3 v2) {
    vec3 vec = new vec3();
    vec.x = v1.y * v2.z - v1.z * v2.y;
    vec.y = -(v1.x * v2.z - v1.z * v2.x);
    vec.z = v1.x * v2.y - v1.y * v2.x;
    
    return vec;
}

float dot(vec3 a, vec3 b) {
  return a.x*b.x + a.y*b.y + a.z*b.z;
}
