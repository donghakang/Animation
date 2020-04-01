import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class boid2 extends PApplet {


ArrayList<Boid> boids = new ArrayList<Boid>();


class Boid {
  vec2 pos;
  vec2 vel;
  vec2 acc;
  float r;
  float neighbor;
  float max_speed;
  float max_force;
  int   boid_num;

  float separation_force = 1.5f;
  float alignment_force  = 1;
  float cohension_force  = 1.3f;

  Boid (float x, float y) {
    pos = new vec2(x, y);
    vel = new vec2(random(-1,1), random(-1,1));
    acc = new vec2();
    r   = 5.0f;
    neighbor  = 100.0f;

    max_speed = 5.0f;
    max_force = 0.05f;

    boid_num = boids.size();
  }




  public void boid() {
    update();
    out();
    compute_boid();
    display();
  }


  public void out() {
    if (pos.x > w) pos.x = 1;
    if (pos.x < 0) pos.x = w-1;
    if (pos.y > h) pos.y = 1;
    if (pos.y < 0) pos.y = h-1;
  }

  public void update() {
    vel = add(vel, acc);
    // if (vel.dist() > max_speed) {
    //   vel = multiply(divide(vel, vel.dist()), max_speed);
    // }
    pos = add(pos, vel);
    acc.set(0,0);
  }


  public void display() {
    // fill(200, 100);
    pushMatrix();
    noStroke();
    circle(pos.x, pos.y, r);
    fill(color(255,100,100));


    popMatrix();
  }


  public void compute_boid() {
    vec2 sep = separation();
    vec2 ali = alignment();
    vec2 coh = cohesion();


    vec2 c   = new vec2();
    c.x = separation_force * sep.x +
          alignment_force  * ali.x +
          cohension_force  * coh.x;
    c.y = separation_force * sep.y +
          alignment_force  * ali.y +
          cohension_force  * coh.y;


    acc = add(acc, c);
    // vel.normalize();
  }


  public vec2 separation() {
    vec2 sep = new vec2();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor/2.0f) {
          vec2 diff = subtract(pos, b.pos);
          diff.normalize();
          divide(diff, distance);
          sep = add(sep, diff);
          count+=1;
        }
      }
    }
    // if there is no neighbors.
    if (count == 0) {
      return sep;
    }
    else {
      // sep = multiply(sep, -1);
      sep = divide(sep, PApplet.parseFloat(count));
    }
    if (sep.dist() > 0) {
      sep.normalize(max_speed);
      sep = subtract(sep, vel);
      sep.normalize(max_force);
    }

    return sep;
  }



  public vec2 alignment() {
    vec2 ali = new vec2();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor) {
          ali = add(ali, b.vel);
          count += 1;
        }
      }
    }
    // if there is no neighbors.
    if (count == 0) {
      return ali;
    }
    else {
      ali = divide(ali, PApplet.parseFloat(count));
      ali.normalize(max_speed);
      ali = subtract(ali, vel);
      ali.normalize(max_force);
      return ali;
    }
  }



  public vec2 cohesion() {
    vec2 coh = new vec2();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor) {
          coh = add(coh, b.pos);
          count += 1;
        }
      }
    }
    // if there is no neighbors.
    if (count == 0) {
      return coh;
    }
    else {
      coh = divide(coh, PApplet.parseFloat(count));
      coh = subtract(coh, pos);
      coh.normalize(max_speed);
      coh = subtract(coh, vel);
      coh.normalize(max_force);
      return coh;
    }
  }
}


int w = 800;
int h = 680;
// float f = 0.0;
// float delta = 0.0;

public void settings() {
  size(800, 680);
}

public void setup() {
  boids.clear();
  for (int i = 0; i < 200; i++) {
    Boid b = new Boid(random(0,w), random(0,h));
    boids.add(b);
  }
}



public void keyPressed() {
  if (keyCode == 'R') {
    setup();
  }
  if (keyCode == 'A') {
    Boid b = new Boid (width/2, height/2);
    boids.add(b);
  }
}


public void draw() {
  // delta = millis() - f;
  // f = millis();
  background(color(0,180,255));

  for (Boid b : boids) {
    b.boid();
  }
}

class vec2 {
  float x, y;

  // Constructor
  vec2() {
    x = 0.0f;
    y = 0.0f;
  }

  vec2(float x_, float y_) {
    x = x_;
    y = y_;
  }

  public vec2 get() {
    return new vec2(x,y);
  }

  public void set(float x_, float y_) {
    x = x_;
    y = y_;
  }

  public float dist() {
    return sqrt(x*x + y*y);
  }

  public void normalize() {
    float division = sqrt(pow(x,2) + pow(y,2));
    x = x / division;
    y = y / division;
  }

  public void normalize(float a) {
    float division = sqrt(pow(x,2) + pow(y,2));
    x = x / division * a;
    y = y / division * a;
  }

  public void set_magnitude(float a) {
    float division = sqrt(pow(x,2) + pow(y,2));
    float val = a / division;
    x = val * x;
    y = val * y;
  }

  public void print() {
    println("(" + str(x) + ", " + str(y) + ")");
  }


}


public vec2 add(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x + b.x;
  vec.y = a.y + b.y;

  return vec;
}

public vec2 subtract(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x - b.x;
  vec.y = a.y - b.y;

  return vec;
}

public vec2 multiply(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x * b.x;
  vec.y = a.y * b.y;

  return vec;
}

public vec2 multiply(vec2 a, float b) {
  a.x = a.x * b;
  a.y = a.y * b;
  return a;
}

public vec2 divide(vec2 a, vec2 b) {
  vec2 vec = new vec2();
  vec.x = a.x / b.x;
  vec.y = a.y / b.y;

  return vec;
}


public vec2 divide(vec2 a, float b) {
  a.x = a.x / b;
  a.y = a.y / b;
  return a;
}

public float dist(vec2 a, vec2 b) {
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "boid2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
