
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
  
  vec3 cross (vec3 v) {
    vec3 vec = new vec3();
    vec.x = y * v.z - z * v.y;
    vec.y = -(x * v.z - z * v.x);
    vec.z = x * v.y - y * v.x;
    
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


float dot(vec3 a, vec3 b) {
  return a.x*b.x + a.y*b.y + a.z*b.z;
}





class vec {
  float x, y;
  
  vec() {
    x = 0;
    y = 0;
  }
  
  vec(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  float dist() {
    return sqrt(x*x + y*y);
  }
  
  vec add(vec a) {
    return new vec(x + a.x, y + a.y);
  }
  
  vec subtract(vec a) {
    return new vec(x - a.x, y - a.y);
  }
  
  vec divideBy(float a) {
    return new vec(x/a, y/a);
  }
  
  
  vec multiplyBy(float a) {
    return new vec(x*a, y*a);
  }
  
  
}

vec d(vec a, vec b) {
   vec v = new vec(a.x/b.x, a.y/b.y);
   return v;
}

vec m(vec a, vec b) {
   vec v = new vec(a.x*b.x, a.y*b.y);
   return v;
}

float dot(vec a, vec b) {
  return a.x * b.x + a.y * b.y;
}


vec normalize(vec a, vec b) {
  vec v = new vec(a.x - b.x, a.y - b.y);
  float d = v.dist();
  return v.divideBy(d);
}
