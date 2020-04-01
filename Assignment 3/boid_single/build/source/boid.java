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

public class boid extends PApplet {


ArrayList<Boid> boids = new ArrayList<Boid>();    // list of fires

class Boid {
  vec2  pos   = new vec2();
  vec2  vel   = new vec2();
  vec2  acc   = new vec2();
  int   boid_num;
  float max_speed;
  float size;
  float detect_r;

  Boid(float x, float y) {
    pos.set(x, y);
    vel.set(random(-3,3), random(-3,3));
    acc.set(0, 0);

    boid_num  = boids.size();
    max_speed = 3;
    size      = 10;
    detect_r  = 200;
  }

  // update position of the boid
  public void edge_detect() {
    pos = add(pos, vel);
    vel = add(vel, acc);
    if (pos.x > w) pos.x = 0;
    if (pos.x < 0) pos.x = w;
    if (pos.y > h) pos.y = 0;
    if (pos.y < 0) pos.y = w;
  }



  public void display() {
    pushMatrix();
    noStroke();
    fill(color(255,0,0));
    circle(pos.x, pos.y, size);
    popMatrix();
  }

  public void display_detect() {
    pushMatrix();
    noStroke();
    fill(color(255,255,0));
    circle(pos.x, pos.y, size);
    popMatrix();
  }

  public void display_main() {
    pushMatrix();
    noStroke();
    fill(color(0,0,0,50));
    circle(pos.x, pos.y, detect_r);
    fill(color(0,255,0));
    circle(pos.x, pos.y, size);
    popMatrix();
  }
}


public void range_detect() {
  Boid base = boids.get(0);
  for (Boid b : boids) {
    if (b.boid_num != 0) {
      if (dist(b.pos, base.pos) < base.detect_r / 2.0f) {
        b.display_detect();
      }
    }
  }
}

// a is the base.
public boolean inRange(Boid a, Boid b) {
  return dist(b.pos, a.pos) < a.detect_r / 2.0f;
}


// BOIDS
public vec2 calculate_boid(Boid base) {
  vec2 cohesion   = new vec2();
  vec2 alignment  = new vec2();
  vec2 separation = new vec2();
  vec2 final_vel  = new vec2();

  for (Boid b : boids) {
    // base case
    if (b.boid_num != base.boid_num) {
      // inside the range
      cohesion = add(cohesion, b.pos);    // cohesion
      alignment  = add(alignment, b.vel);
      if (inRange(base, b)) {
        vec2 temp = subtract(b.pos, base.pos);
        separation = subtract(separation, temp);
      }
    }
  }
  cohesion = divide(cohesion, boids.size()-1);
  cohesion = subtract(cohesion, base.pos);
  cohesion = divide(cohesion, 100);

  alignment = divide(alignment, boids.size()-1);
  alignment = subtract(cohesion, base.vel);
  alignment = divide(alignment, 8);

  separation = divide(separation, 100);
  separation.print();

  final_vel.x = cohesion.x + alignment.x + separation.x;
  final_vel.y = cohesion.y + alignment.y + separation.y;

  return final_vel;
}

public void update() {
  // for (int i = 0; i < boids.size(); i++) {
    Boid base = boids.get(0);
    vec2 final_vel = calculate_boid(base);

    base.vel = add(base.vel, final_vel);
    if (base.vel.dist() > base.max_speed) {
      base.vel = multiply(divide(base.vel, base.vel.dist()), base.max_speed);
    }
    base.pos = add(base.pos, base.vel);

}

int w = 750;
int h = 750;
String s = "";
boolean boid_on = true;



public void settings() {
  size(750, 750);
}

public void setup() {
  background(color(255,255,255));
  surface.setTitle("boid");
  init();
}

public void init() {
  boids.clear();

  for (int i = 0; i < 100; i ++) {
    Boid a;
    if (i == 0) {
      a = new Boid(w/2, h/2);
    } else {
      a = new Boid(random(0, w), random(0, h));
    }
    boids.add(a);
  }
}


public void mousePressed() {
  Boid a = new Boid(mouseX, mouseY);
  boids.add(a);
}


public void keyPressed() {
  if (keyCode == 'O') {
    boid_on = !boid_on;
  }
  if (keyCode == 'R') {
    init();
  }
}


public void draw() {
  background(color(255,255,255));
  surface.setTitle(str(frameRate));

  for (int i = 0; i < boids.size(); i ++) {
    boids.get(i).edge_detect();
    if (i == 0) boids.get(i).display_main();
    else boids.get(i).display();
    range_detect();
  }

  if (boid_on) update();



  pushMatrix();
  fill(color(255));
  textSize(25);
  s = "Number of boids: " + str(boids.size());
  text(s, 15, 50);
  popMatrix();

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
    String[] appletArgs = new String[] { "boid" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
