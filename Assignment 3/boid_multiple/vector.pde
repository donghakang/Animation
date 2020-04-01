
class vec2 {
  float x, y;

  // Constructor
  vec2() {
    x = 0.0;
    y = 0.0;
  }

  vec2(float x_, float y_) {
    x = x_;
    y = y_;
  }

  vec2 get() {
    return new vec2(x,y);
  }

  void set(float x_, float y_) {
    x = x_;
    y = y_;
  }

  float dist() {
    return sqrt(x*x + y*y);
  }

  void normalize() {
    float division = sqrt(pow(x,2) + pow(y,2));
    x = x / division;
    y = y / division;
  }

  void normalize(float a) {
    float division = sqrt(pow(x,2) + pow(y,2));
    x = x / division * a;
    y = y / division * a;
  }

  void set_magnitude(float a) {
    float division = sqrt(pow(x,2) + pow(y,2));
    float val = a / division;
    x = val * x;
    y = val * y;
  }

  void print() {
    println("(" + str(x) + ", " + str(y) + ")");
  }


}


vec2 add(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x + b.x;
  vec.y = a.y + b.y;

  return vec;
}

vec2 subtract(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x - b.x;
  vec.y = a.y - b.y;

  return vec;
}

vec2 multiply(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x * b.x;
  vec.y = a.y * b.y;

  return vec;
}

vec2 multiply(vec2 a, float b) {
  a.x = a.x * b;
  a.y = a.y * b;
  return a;
}

vec2 divide(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x / b.x;
  vec.y = a.y / b.y;

  return vec;
}


vec2 divide(vec2 a, float b) {
  a.x = a.x / b;
  a.y = a.y / b;
  return a;
}

float dist(vec2 a, vec2 b) {
  return sqrt(pow(b.x - a.x,2) + pow(b.y - a.y, 2));
}

// vec3 cross (vec3 v1, vec3 v2) {
//     vec3 vec = new vec3();
//     vec.x = v1.y * v2.z - v1.z * v2.y;
//     vec.y = -(v1.x * v2.z - v1.z * v2.x);
//     vec.z = v1.x * v2.y - v1.y * v2.x;
//
//     return vec;
// }
//
// float dot(vec3 a, vec3 b) {
//   return a.x*b.x + a.y*b.y + a.z*b.z;
// }
