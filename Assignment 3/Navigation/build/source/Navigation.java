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

public class Navigation extends PApplet {




int number_of_points = 300;
int total_points = number_of_points + 2;



ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
Point[] points = new Point[total_points];

ArrayList<Path> paths = new ArrayList<Path>();
ArrayList<Path> realpath = new ArrayList<Path>();
// ArrayList<Point> points = new ArrayList<Point>();
// Point[] agents = new Point[2];


class Obstacle {
  vec2 pos;
  float size;

  Obstacle(float x, float y) {
    pos = new vec2(x, y);
    size = random(50, 80);
  }

  public void display() {
    fill(200, 100);
    noStroke();
    pushMatrix();
    circle(pos.x, pos.y, size);
    popMatrix();
  }
}




class Point{
  vec2 pos;

  Point() {
    pos = new vec2(-1, -1);
  }

  Point(float x_, float y_) {
    pos = new vec2(x_, y_);
  }

  public void set(Point p) {
    pos = p.pos;
  }

  public float distance(Point a) {
    return dist(pos, a.pos);
  }

  public void print() {
    pos.print();
  }

  public boolean inCanvas() {
    return pos.x > 0 && pos.x < width && pos.y > 0 && pos.y < height;
  }

  public boolean inObstacle() {
    for (Obstacle o : obstacles) {
      if (dist(o.pos, pos) < o.size/2.0f) {
        return true;
      }
    }
    return false;
  }

  public void relocate() {
    pos = new vec2(random(0, width), random(0, height));
  }


  public void display_start() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255);
    textSize(15);
    text("START", -15, -5);
    fill(color(0,255,0));
    noStroke();
    circle(0, 0, 5);
    popMatrix();
  }

  public void display_dest() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255);
    textSize(15);
    text("END", -12, -5);
    fill(color(255,0,0));
    noStroke();
    circle(0, 0, 5);
    popMatrix();
  }

  public void display() {
    pushMatrix();
    stroke(color(255,255,255));
    point(pos.x,pos.y);
    // fill(255);
    // circle(pos.x,pos.y,3);
    popMatrix();
  }

  public void display(int n) {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(255);
    textSize(15);
    text(str(n), 0,0);
    stroke(color(255,255,255));
    point(0,0);
    // fill(255);
    // circle(pos.x,pos.y,3);
    popMatrix();
  }
}




// Path
class Path {
  Point a;
  Point b;
  float d;
  int   start, end;

  Path(Point p1, Point p2) {
    a = p1;
    b = p2;
    d = p1.distance(p2);
  }

  Path(Point p1, Point p2, int s, int e) {
    a = p1;
    b = p2;
    d = p1.distance(p2);
    start = s;
    end   = e;
  }


  public boolean intersect() {
    for (Obstacle o : obstacles) {
      float len = d;
      float dot = ((o.pos.x - a.pos.x)*(b.pos.x-a.pos.x) +
                   (o.pos.y - a.pos.y)*(b.pos.y-a.pos.y)) / (len*len);

      float closestX = a.pos.x + (dot * (b.pos.x-a.pos.x));
      float closestY = a.pos.y + (dot * (b.pos.y-a.pos.y));

      Point closest = new Point(closestX, closestY);
      float d1 = closest.distance(a);
      float d2 = closest.distance(b);
      if (d1 + d2 >= len-0.1f && d1 + d2 <= len + 0.1f) {
        float distance = dist(closest.pos, o.pos);
        if ( distance <= o.size / 2 ) {
         return true;
        }
      }
    }
    return false;
  }


  public void print() {
    println("FROM: (", a.pos.x, a.pos.y, ")     TO: (", b.pos.x, b.pos.y, ")");
    // println("======START POSITION :", start_pos);
    // println("======  END POSITION :", end_pos);
  }

  public void display() {
    pushMatrix();
    stroke(color(0,255,0,20));
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
    popMatrix();
  }

  public void display_red() {
    pushMatrix();
    stroke(color(255,0,0));
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
    popMatrix();
  }
}


public void clear_path() {
  dijkstra_path.clear();
  A_path.clear();

  paths.clear();
  realpath.clear();

}

public void connect_path() {
  if (isValid()) {
    for (int i = 0; i < total_points; i ++) {
      for (int j = i+1; j < total_points; j ++) {
        Point p1 = points[i];
        Point p2 = points[j];
        Path  p  = new Path(p1, p2, i, j);
        if (!p.intersect()) {
          // p.display();
          paths.add(p);
        }
      }
    }
  }
}

public boolean isValid() {
  if (points[0].pos.x < 0 || points[1].pos.x > width ||
      points[1].pos.y < 0 || points[1].pos.y > height) {
    return false;
  } else {
    return true;
  }
}





// display all
public void display_PRM() {
  clear_path();


  points[0].display_start();
  points[1].display_dest();

  // MARK: OBSTACLE
  for (Obstacle o : obstacles) {
    o.display();
  }


  // MARK: POINTS
  for (int i = 0; i < total_points; i ++) {
    Point p = points[i];
    if (!p.inObstacle()) {
      // p.display();
    } else {
      p.relocate();
    }
  }

  // MARK: PATHS
  connect_path();
  // for (Path path : paths) {
  //   path.display();
  // }

  if (NAVIGATION_MODE) Dijkstra();
  else if (!NAVIGATION_MODE) A_();

  for (Path path : realpath) {
    path.display_red();
    // path.print();
  }

  if (SHOW_PATH) {
    if (NAVIGATION_MODE) {
      for (Path path : dijkstra_path) {
        path.display();
        // path.print();
      }
    }

    if (!NAVIGATION_MODE) {
      for (Path path : A_path) {
        path.display();
        // path.print();
      }
    }
  }

}

ArrayList <Path> dijkstra_path = new ArrayList<Path>();
ArrayList <Path> A_path = new ArrayList<Path>();


public boolean visited(boolean[] visit) {
  for (int i = 0; i < total_points; i ++) {
    if (visit[i] == false) return false;
  }
  return true;
}


public int minDistance(float dist[], boolean Q[]) {
    // Initialize min value
    float min = 100000.0f;
    int min_index = 0;


    for (int i = 0; i < total_points; i++) {
      if (Q[i] == false && dist[i] <= min) {
        min = dist[i];
        min_index = i;
      }
    }

    return min_index;
}

public IntList neighbor(int u, boolean[] Q) {
  IntList list = new IntList();
  for (Path p : paths) {
    if (p.start == u) {
      list.append(p.end);
    }
    if (p.end == u) {
      list.append(p.start);
    }
  }

  int count = 0;
  for (int i : list) {
    if (Q[i]) {
      list.remove(count);
    } else {
      count += 1;
    }
  }

  return list;
}

public void find_real_path(int[] parent, int source, int destination) {
  while ( destination != source && parent[destination] != -1) {
    Point b = points[destination];
    Point a = points[parent[destination]];

    realpath.add(new Path(a, b));

    destination = parent[destination];
  }
}


public void Dijkstra(){
  // path --> Graph
  // point -> Vertex
  temp__time = millis();
  float[] dist = new float[total_points];
  boolean[] Q  = new boolean[total_points];
  int[] parent = new int[total_points];
  int source = 0;

  for (int i = 0; i < total_points; i ++) {
    if (i == source) dist[source] = 0.0f;
    else             dist[i]      = 100000.0f;
    parent[i] = -1;
    Q[i] = false;
  }

  for (int j = 0; j < total_points; j ++) {

    int u = minDistance(dist, Q);
    Q[u]  = true;

    for (int v : neighbor(u, Q)) {
      float alt = dist[u] + points[u].distance(points[v]);
      if ( Q[v] == false && alt < dist[v]) {
        // path!
        Path path = new Path(points[u], points[v]);
        dijkstra_path.add(path);

        parent[v] = u;
        dist[v] = alt;
      }
    }
  }

  if (isValid()) {
    find_real_path(parent, 0, 1);
  }

  total_time = millis() - temp__time;
  IS_PRM = true;    // trigger
}


//============================================================


public void A_ () {

  temp__time = millis();
  float[] dist = new float[total_points];
  boolean[] Q  = new boolean[total_points];
  int[] parent = new int[total_points];
  int source = 0;
  int destination = 1;

  for (int i = 0; i < total_points; i ++) {
    if (i == source) dist[source] = 0.0f;
    else             dist[i]      = 100000.0f;
    parent[i] = -1;
    Q[i] = false;
  }

  for (int j = 0; j < total_points; j ++) {
    int u = minDistance(dist, Q);
    Q[u]  = true;

    for (int v : neighbor(u, Q)) {
      float alt = dist[u] + points[u].distance(points[v]) +
                  points[u].distance(points[destination]);
      if ( Q[v] == false && alt < dist[v]) {
        Path path = new Path(points[u], points[v]);
        A_path.add(path);
        parent[v] = u;
        dist[v] = alt;
      }
    }
  }

  if (isValid()) {
    find_real_path(parent, 0, 1);
  }

  total_time = millis() - temp__time;
  IS_PRM = true;    // trigger
}


public Point rand_configuration() {
  Point p = new Point();

  while (p.inObstacle()) {
    println("HI");
    p.relocate();
  }
  return p;
}

public Point nearest_vertex(Point q, ArrayList<Point> V) {
  Point p = V.get(0);
  for (Point v : V) {
    if (v.distance(q) < p.distance(q) && v.distance(p) > 0.01f) {
      p.set(v);
    }
  }
  return p;
}

public Point new_configuration(Point n, Point r, float epsilon) {
  if (n.distance(r) < epsilon) {
    return n;
  } else {
    vec2 destination = r.pos;
    vec2 start       = n.pos;
    vec2 dir = subtract(destination, start);
    dir.normalize();
    Point p = new Point (n.pos.x + epsilon*dir.x, n.pos.y + epsilon*dir.y);
    return p;
  }
}

ArrayList<Path> rrt_path = new ArrayList<Path>();


public void RRT() {
  int source = 0;
  float d_q  = 7.0f;

  // ArrayList <Path> G = new ArrayList<Path>();
  ArrayList <Point> V = new ArrayList<Point>();
  V.add(points[source]); // init

  for ( int v = 0; v < total_points; v ++ ){
    Point rand = rand_configuration();

    Point near = nearest_vertex(rand, V);
    Point qnew = new_configuration(near, rand, d_q);
    V.add(qnew);
    rrt_path.add(new Path(near, qnew));
  }
}



public void display_RRT() {
  // clear_path();
  rrt_path.clear();
  points[0].display_start();
  points[1].display_dest();
  for (Obstacle o : obstacles) {
    o.display();
  }


  // MARK: POINTS
  for (int i = 0; i < total_points; i ++) {
    Point p = points[i];
    if (!p.inObstacle()) {
      // p.display();
    } else {
      p.relocate();
    }
  }

  RRT();


  for (Path p : rrt_path) {
    p.display();
  }
  // print(rrt_path.size());
}


Actor actor = new Actor();


class Actor {
  float x, y;
  //float s_x, s_y;        // slope
  //float s_length;        // distance
  int path_position;   // path position
  float vel;
  float radius = 15.0f;

  Actor() {
    x = 0;
    y = 0;
    //s_x = 0;
    //s_y = 0;
    //s_length = 0;
    path_position = 0;
    vel    = 5;
  }

  public void init_pos() {
    int s = realpath.size();
    path_position = s - 1;
    x = realpath.get(s-1).a.pos.x;
    y = realpath.get(s-1).a.pos.y;
  }

  public void change_pos() {

    float distX = realpath.get(path_position).b.pos.x - x;
    float distY = realpath.get(path_position).b.pos.y - y;

    float distance = sqrt(distX*distX + distY*distY);
    // println(distance, radius);
    if ( distance < radius/4 ) {
      path_position -= 1;
    }
  }

  public void update() {
    Path p = realpath.get(path_position);
    float startX = p.a.pos.x;
    float startY = p.a.pos.y;
    float endX   = p.b.pos.x;
    float endY   = p.b.pos.y;

    float s_y = endY - startY;
    float s_x = endX - startX;

    float s_length = dist(p.a.pos, p.b.pos);

    x += s_x / s_length * vel;
    y += s_y / s_length * vel;
  }


  // actor display
  public void display() {
    pushMatrix();
    fill(color(255,255,255));
    stroke(color(255,255,255));
    circle(x, y, radius);
    popMatrix();
  }
}

boolean OBSTACLE_MODE   = false;
boolean NAVIGATION_MODE = false;
boolean SHOW_PATH       = false;
boolean IS_PRM          = false;

boolean AGENT_MOVEMENT  = false;

public void settings() {
  size(800, 600);
}


public void init() {
  background(0);
  points[0] = new Point(-1, -1);
  points[1] = new Point(width+1, height+1);
  paths.clear();
  obstacles.clear();
  // for (int i = 0; i < 10; i ++) {
  //   obstacles.add(new Obstacle(random(width), random(height)));
  // }

  for (int i = 2; i < total_points; i ++) {
    Point p = new Point();
    p.relocate();
    points[i] = p;
  }
}

public void setup() {
  init();
}


public void keyPressed() {
  if (keyCode == 'O') {
    OBSTACLE_MODE = !OBSTACLE_MODE;
  }
  if (keyCode == 'R') {
    init();
  }
  if (keyCode == '1') {
    NAVIGATION_MODE = true;
  }
  if (keyCode == '2') {
    NAVIGATION_MODE = false;
  }
  if (keyCode == 'M') {
    SHOW_PATH = !SHOW_PATH;
  }
  if (keyCode == ENTER) {
    if (!AGENT_MOVEMENT) {
      if (realpath.size() > 0) {
        actor.init_pos();
      }
    }
    AGENT_MOVEMENT = !AGENT_MOVEMENT;
  }
}

public void mousePressed() {
  if (mouseButton == LEFT) {
    if (OBSTACLE_MODE) {
      obstacles.add(new Obstacle(mouseX, mouseY));
      if (realpath.size() > 0) {
        actor.init_pos();
      }
    }
    else {
      points[0] = new Point(mouseX, mouseY);
      // set up agents
      if (realpath.size() > 0) {
        actor.init_pos();
      }
    }
  } else if (mouseButton == RIGHT) {
    if (OBSTACLE_MODE) {
      obstacles.add(new Obstacle(mouseX, mouseY));
      if (realpath.size() > 0) {
        actor.init_pos();
      }
    }
    else {
      points[1] = new Point(mouseX, mouseY);
      if (realpath.size() > 0) {
        actor.init_pos();
      }
    }
  } else {
    background(126);
  }
}

float total_time = 0.0f;
float temp__time = 0.0f;
public void explanation() {
  String ex = "";
  String ob = "Click 'R' to restart \n\n";
  if (NAVIGATION_MODE) {
    String mode = "Dijkstra";
    String num  = "# of paths : " + str(dijkstra_path.size());
    String time = "time takes : " + str(total_time);
    ex = mode + "\n" + num + "\n" + time;
  } else {
    String mode = "A*";
    String num  = "# of paths : " + str(A_path.size());
    String time = "time takes : " + str(total_time);
    ex = mode + "\n" + num + "\n" + time;
  }

  pushMatrix();
  translate(20, 50);
  fill(255);
  textSize(18);
  text(ex, 0,0);
  stroke(color(255,255,255));
  point(0,0);
  popMatrix();


  if (OBSTACLE_MODE) {
    ob += "Click to put obstacles";
    ob += "\n\nClick 'O' to set\nstart and end position";
  } else {
    ob += "Left Click to put start point";
    ob += "\nRight Click to put end point";
    ob += "\n\nClick 'O' to set\nobstacle position";
  }

  if (AGENT_MOVEMENT) {
    ob += "\n\nClick 'ENTER' to reset \nobstacles and start/end points";
  } else {
    ob += "\n\nClick 'ENTER' to \n play animation";
  }

  pushMatrix();
  translate(width-250, 50);
  fill(255);
  textSize(18);
  text(ob, 0,0);
  stroke(color(255,255,255));
  point(0,0);
  popMatrix();
}






public void draw() {
  background(0);

  // Path p = new Path();
  // p.print();
  explanation();

  if (!AGENT_MOVEMENT) display_PRM();
  else {
    // MARK: OBSTACLE

    if (realpath.size() > 0) {
      points[0].display_start();
      points[1].display_dest();
      for (Obstacle o : obstacles) {
        o.display();
      }
      for (Path p : realpath) {
        p.display_red();
      }
      if (actor.path_position >= 0) {
        actor.update();
        actor.change_pos();
      }
      actor.display();
    }
  }


  // }

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
    String[] appletArgs = new String[] { "Navigation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
