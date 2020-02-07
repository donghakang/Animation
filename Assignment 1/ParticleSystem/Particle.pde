
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
  
  float dot(vec3 v) {
    return x * v.x + y * v.y + z * v.z;
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
  
  vec3 multiply(float a) {
    vec3 vec = new vec3();
    vec.x = x * a;
    vec.y = y * a;
    vec.z = z * a;
    return vec;
    
  }
  
  vec3 cross (vec3 v) {
    vec3 vec = new vec3();
    vec.x = y * v.z - z * v.y;
    vec.y = -(x * v.z - z * v.x);
    vec.z = x * v.y - y * v.x;
    
    return vec;
  }
  
  float distance(vec3 v) {
    return sqrt(pow(x - v.x, 2) + pow(y - v.y, 2) + pow(z - v.z, 2));
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

class Particle {
  vec3 pos;
  vec3 vel;
  color c;
  float s;

}
