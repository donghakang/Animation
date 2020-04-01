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

public class fishtank extends PApplet {


ArrayList<Boid> boids = new ArrayList<Boid>();


class Boid {
  vec3 pos;
  vec3 vel;
  vec3 acc;
  float r;
  float neighbor;
  float max_speed;
  float max_force;
  int   boid_num;

  float separation_force = 4;
  float alignment_force  = 4;
  float cohension_force  = 4;

  Boid (float x, float y, float z) {
    pos = new vec3(x, random(0,300), z);
    vel = new vec3(random(-1, 1), random(-1,1), random(-1,1));
    acc = new vec3();
    r   = 5.0f;
    neighbor  = 100.0f;

    max_speed = 7.0f;
    max_force = 0.1f;

    boid_num = boids.size();
  }

  public void boid() {
    update();
    out();
    compute_boid();
    //if (vel.dist() > max_speed) {
      vel.normalize(max_speed);
    //}
    display();
  }


  public void out() {
    if (pos.x > w) pos.x = 1;
    if (pos.x < 0) pos.x = w-1;
    // if (pos.y > h) pos.y = 1;
    // if (pos.y < 0) pos.y = h-1;
    //if (pos.z > s) pos.z = 1;
    //if (pos.z < 0) pos.z = s-1;

     //if (pos.x > w - 10) vel.x = -1 * vel.x;
     //if (pos.x < 10)     vel.x = -1 * vel.x;
     if (pos.y > h - 10) vel.y = -2 * vel.y;
     if (pos.y < 10)     vel.y = -2 * vel.y;
     if (pos.z > s - 3) {
       pos.z -= 0.01f;
       vel.z = -2 * vel.z;
     }
     if (pos.z < 3) {
       pos.z += 0.01f;
       vel.z = -2 * vel.z;
     }
  }

  public void update() {
    if (boid_num >= 0 && boid_num <= 10) {
      vel.set(-max_speed-1,random(-1,1),0);
    } else {
      vel = add(vel, acc);

      acc.y = 0;
      vel.y = 0;
    }

    pos = add(pos, vel);
    acc.set(0,0,0);
  }


  public void display() {
    // fill(200, 100);
    vec3 r = vel.heading3D();
    pushMatrix();
    // shininess(20.0);
    translate(pos.x, pos.y, pos.z);
    rotateX(PI/2);
    shape(fish, 0, 0);
    // beginShape(TRIANGLES);
    // vertex(0, -5*2, 0 );
    // vertex(-5, 5*2, 0);
    // vertex(5, 5*2, 0);
    // vertex(0, -5*2, 0 );
    // vertex(0, 5*2, -5);
    // vertex(0, 5*2, 5);
    // endShape();
    // fill(color(255,100,100));


    popMatrix();
  }


  public void compute_obstacle(Obstacles obs) {
    for (Obstacle o : obs.obstacles) {
      // separation force
      if (dist(pos, o.pos) < o.size) {
        vec3 sep = separation();
      }
    }
  }


  public void compute_boid() {
    vec3 sep = separation();
    vec3 ali = alignment();
    vec3 coh = cohesion();


    vec3 c   = new vec3();
    c.x = separation_force * sep.x +
          alignment_force  * ali.x +
          cohension_force  * coh.x;
    c.y = separation_force * sep.y +
          alignment_force  * ali.y +
          cohension_force  * coh.y;
    c.z = separation_force * sep.z +
          alignment_force  * ali.z +
          cohension_force  * coh.z;

    acc = add(acc, c);
    // vel.normalize();
    //vel.x += 1;
  }


  public vec3 separation() {
    vec3 sep = new vec3();
    int count = 0;

    for (Boid b : boids) {
      float distance = dist(pos, b.pos);
      if (b.boid_num != boid_num) {
        if (distance < neighbor/2.0f) {
          vec3 diff = subtract(pos, b.pos);
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



  public vec3 alignment() {
    vec3 ali = new vec3();
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



  public vec3 cohesion() {
    vec3 coh = new vec3();
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
// Created for CSCI 5611 by Liam Tyler and Stephen Guy

class Camera
{
  Camera()
  {
    position      = new PVector( -5, -170, 325 ); // initial position
    theta         = 0; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = -0.4588874f; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = 100;
    turnSpeed     = 1.57f; // radians/sec
     

    // dont need to change these
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1f;
    farPlane         = 10000;
  }

  public void print() {
    println(position, theta, phi); 
  }
  
  public void dimensional_view() {
    position  = new PVector(-343.6f, -343.6f, 894.9f);
    theta     = -0.94763947f;
    phi       = -0.43416837f;
  }
  
  public void top_view() {
    position  = new PVector(738.7871f, -922.69147f, 385.6621f);
    theta     = 0.0f;
    phi       = -1.4836f;
  }

  public void Update( float dt )
  {
    theta += turnSpeed * (negativeTurn.x + positiveTurn.x) * dt;

    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = 85 * PI / 180;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );

    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
    // except that their theta and phi are named opposite
    float t = theta + PI / 2;
    float p = phi + PI / 2;
    PVector forwardDir = new PVector( sin( p ) * cos( t ), cos( p ), -sin( p ) * sin ( t ) );
    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
    position.add( PVector.mult( upDir, moveSpeed * velocity.y * dt ) );
    position.add( PVector.mult( rightDir, moveSpeed * velocity.x * dt ) );

    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y, position.z,
      position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
      upDir.x, upDir.y, upDir.z );
  }

  // only need to change if you want difrent keys for the controls
  public void HandleKeyPressed()
  {
    if ( key == 'w' ) positiveMovement.z = 1;
    if ( key == 's' ) negativeMovement.z = -1;
    if ( key == 'a' ) negativeMovement.x = -1;
    if ( key == 'd' ) positiveMovement.x = 1;
    if ( key == 'q' ) positiveMovement.y = 1;
    if ( key == 'e' ) negativeMovement.y = -1;

    if ( key == 'j' )  negativeTurn.x = 1;
    if ( key == 'l' )  positiveTurn.x = -1;
    if ( key == 'i' )  positiveTurn.y = 1;
    if ( key == 'k' )  negativeTurn.y = -1;
  }


  // only need to change if you want difrent keys for the controls
  public void HandleKeyReleased()
  {
    if ( key == 'w' ) positiveMovement.z = 0;
    if ( key == 'q' ) positiveMovement.y = 0;
    if ( key == 'd' ) positiveMovement.x = 0;
    if ( key == 'a' ) negativeMovement.x = 0;
    if ( key == 's' ) negativeMovement.z = 0;
    if ( key == 'e' ) negativeMovement.y = 0;

    if ( key == 'j' )  negativeTurn.x = 0;
    if ( key == 'l' )  positiveTurn.x = 0;
    if ( key == 'i' )  positiveTurn.y = 0;
    if ( key == 'k' )  negativeTurn.y = 0;
  }

  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;

  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
};
Camera camera;
PShape fish;
PShape rock;

int w = 3000;
int h = 400;
int s = 600;
// float f = 0.0;
// float delta = 0.0;

Obstacle o = new Obstacle();

public void settings() {
  size(800, 680, P3D);
}

public void setup() {
  camera = new Camera();
  camera.dimensional_view();
  fish = loadShape("./data/12265_Fish_v1_L2.obj");
  fish.scale(2);

  rock = loadShape("./data/stone_podest_OBJ.obj");
  rock.scale(30);
  rock.rotateX(PI);


  boids.clear();
  for (int i = 0; i < 200; i++) {
    Boid b = new Boid(random(0,w), random(0,h), random(0, s));
    boids.add(b);
  }

  Obstacles o = new Obstacles();



}



public void keyPressed() {
  camera.HandleKeyPressed();

  if (keyCode == 'R') {
    setup();
  }
  if (keyCode == 'P') {
    Boid b = new Boid(random(0,w), random(0,h), random(0, s));
    boids.add(b);
  }
  if (keyCode == '1') {
    camera.dimensional_view();
  }
  if (keyCode == '2') {
    camera.top_view();
  }
}

public void keyReleased()
{
  camera.HandleKeyReleased();
}

public void display_box () {
  pushMatrix();
  // noFill();
  noFill();
  translate(w/2, h/2, s/2);
  box(w,h,s);
  popMatrix();
}



public void draw() {
  background(color(0, 100,255));
  lights();
  display_box();
  camera.Update( 1.0f/frameRate );
  //camera.print();
  for (Boid b : boids) {
    b.boid();
  }

  o.display();


}


int obstacles_num = 5;
class Obstacle {
  vec3 pos;
  float size;

  Obstacle() {
    pos  = new vec3(random(0, w), h, random(0, s));
    size = 30;

  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);

    shape(rock, 0, 0);
    popMatrix();

    // pushMatrix();
    // fill(255);
    // circle(0, 0, 120);
    // popMatrix();
  }
}

class Obstacles {
  ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

  Obstacles() {
    for (int i = 0; i < obstacles_num; i ++) {
      Obstacle n = new Obstacle();
      obstacles.add(n);
    }
  }


  public void display() {
    for (Obstacle o : obstacles) {
      o.display();
    }

    print(obstacles.size());
  }
}

class vec3 {
  float x, y, z;

  // Constructor
  vec3() {
    x = 0.0f;
    y = 0.0f;
    z = 0.0f;
  }

  vec3(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
  }

  public vec3 get() {
    return new vec3(x,y,z);
  }

  public void set(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
  }

  public float dist() {
    return sqrt(x*x + y*y + z*z);
  }

  public void normalize() {
    float division = sqrt(pow(x,2) + pow(y,2) + pow(z,2));
    x = x / division;
    y = y / division;
    z = z / division;
  }

  public void normalize(float a) {
    float division = sqrt(pow(x,2) + pow(y,2) + pow(z,2));
    x = x / division * a;
    y = y / division * a;
    z = z / division * a;
  }

  public void set_magnitude(float a) {
    float division = sqrt(pow(x,2) + pow(y,2) + pow(z,2));
    float val = a / division;
    x = val * x;
    y = val * y;
    z = val * z;
  }

  public vec3 heading3D() {
    vec3 heading = new vec3();
    float rho = atan(y / z);
    // float phi = asin(z / rho);
    float phi = -atan(-z / x);
    float theta = atan(y / x);
    heading.set(rho, phi, theta);
    return heading;
  }

  public void print() {
    println("(" + str(x) + ", " + str(y) + ", " + str(z) + ")");
  }


}


public vec3 add(vec3 a, vec3 b) {
  vec3 vec = new vec3();
  vec.x = a.x + b.x;
  vec.y = a.y + b.y;
  vec.z = a.z + b.z;

  return vec;
}

public vec3 subtract(vec3 a, vec3 b) {
  vec3 vec = new vec3();
  vec.x = a.x - b.x;
  vec.y = a.y - b.y;
  vec.z = a.z - b.z;

  return vec;
}

public vec3 multiply(vec3 a, vec3 b) {
  vec3 vec = new vec3();
  vec.x = a.x * b.x;
  vec.y = a.y * b.y;
  vec.z = a.z * b.z;

  return vec;
}

public vec3 multiply(vec3 a, float b) {
  a.x = a.x * b;
  a.y = a.y * b;
  a.z = a.z * b;
  return a;
}

public vec3 divide(vec3 a, vec3 b) {
  vec3 vec = new vec3();
  vec.x = a.x / b.x;
  vec.y = a.y / b.y;
  vec.z = a.z / b.z;
  return vec;
}


public vec3 divide(vec3 a, float b) {
  a.x = a.x / b;
  a.y = a.y / b;
  a.z = a.z / b;
  return a;
}

public float dist(vec3 a, vec3 b) {
  return sqrt(pow(b.x - a.x,2) + pow(b.y - a.y, 2) + pow(b.z - a.z, 2));
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

public float dot(vec3 a, vec3 b) {
  return a.x * b.x + a.y * b.y + a.z * b.z;
}



// ===========================================================



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

public float dot(vec2 a, vec2 b) {
  return a.x * b.x + a.y * b.y;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "fishtank" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
