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

public class Path_Finding extends PApplet {

// Dongha Kang
// AI Point finder






//Create Window
public void setup() {
  
  noStroke();
  surface.setTitle("Point Finding");
  
  init();
  actor.init_pos();
}




public void keyPressed() {
  if (keyCode == 'R') {
    init();
    actor.init_pos();
  }
  if (keyCode == 'P') {
    visualize_path = !visualize_path;
  }
}



//Draw the scene: one sphere per mass, one line connecting each pair
public void draw() {
  background(25,25,25);
  
  // DEFAULT
  pushMatrix();
  noStroke();
  fill(255,0,0);
  circle(10,490,5);
  fill(0,255,0);
  circle(490,10,5);
  popMatrix();
  
  
  // Obstacle
  pushMatrix();
  //noFill();
  fill(color(25,25,225,80));
  stroke(color(25,25,225));
  circle(obstacle.x, obstacle.y, radius*2);
  popMatrix();
  
  
  if (visualize_path){
    for (Path p : paths) {
      p.display();  
    }
  }
  
  for (Path rp : realpath) {
    rp.display_red();
  }
  
  //// Actor
  
  if (actor.path_position >= 0) {
    actor.update();
    actor.change_pos();
  }
    
  actor.display(); 
}



class Actor {
  float x, y;
  //float s_x, s_y;        // slope 
  //float s_length;        // distance
  int path_position;   // path position
  float vel;
  float radius;
  
  Actor() {
    x = 0;
    y = 0;
    //s_x = 0;
    //s_y = 0;
    //s_length = 0;
    path_position = 0;
    vel    = 5;
    radius = actor_radius;
  }
  
  public void init_pos() {
    int s = realpath.size();
    path_position = s - 1;
    x = realpath.get(s-1).a.x;
    y = realpath.get(s-1).a.y;
  }
  
  public void change_pos() {
      
    float distX = realpath.get(path_position).b.x - x;
    float distY = realpath.get(path_position).b.y - y;
    
    float distance = sqrt(distX*distX + distY*distY);
    println(distance, radius);
    if ( distance < radius/4 ) {
      path_position -= 1;
    } 
  }
  
  public void update() {
    Path p = realpath.get(path_position);
    float startX = p.a.x;
    float startY = p.a.y;
    float endX   = p.b.x;
    float endY   = p.b.y;
    
    float s_y = endY - startY;
    float s_x = endX - startX;
    
    float s_length = dist(p.a, p.b);
    
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

public int min_dist(IntList Q, FloatList dist) {
  int   pos = 0;
  float min = 1000;

  for (int q = 0; q < Q.size(); q++) {
    if (Q.get(q) == 0) {
      if ( dist.get(q) < min ) {
        min = dist.get(q);
        pos = q;
      }
    }
  }
  // dist
  return pos;
}


public IntList vertex_neighbor(int v, IntList Q) {
  IntList list = new IntList();
  for (Path p : paths) {
    if (p.start_pos == v) {
      list.append(p.end_pos);
    }
  }

  int pos = 0;
  for (int l : list) {
    if (Q.get(l) == 1) {
      list.remove(pos);
    }
    else {
      pos += 1;
    }
  }

  return list;
}


public void findRealPath(IntList parent_list) {
  int num = number_of_points - 1;

  while ( num != 0 ) {
    Point b = points.get(num);
    Point a = points.get(parent_list.get(num));

    realpath.add(new Path(a, b));

    num = parent_list.get(num);
  }
}


public void Dijkstra() {
// start 0
// end 29
  FloatList dist   = new FloatList();      // distance measure
  IntList   Q      = new IntList();        // vertex point (0, 1)
  IntList   parent = new IntList();        // parent position

  // initialization
  for (int i = 0; i < number_of_points; i ++ ) {
    Q.append(0);
    parent.append(-1);
    if (i == 0) dist.append(0.0f);
    else dist.append(1000.0f);
  }


  for (int i = 0; i < number_of_points; i ++) {
    int u = min_dist(Q, dist);
    Q.set(u, 1);        // set as visited

    for ( int v : vertex_neighbor(u, Q) ) {
      float alt = dist.get(u) + dist(points.get(u), points.get(v));
      if ( Q.get(v) == 0 && alt < dist.get(v)) {
        parent.set(v, u);
        dist.set(v, alt);
      }
    }
  }

  findRealPath(parent);

  print("dist: ");
  println(dist.size());
  print("Q   : ");
  println(Q.size());
  print("pare: ");
  println(parent.size());
  //for (int i = realpath.size()-1; i >= 0; i--) {
  //  realpath.get(i).print();
  //  println("-----------------------------", realpath.size(), "-----");
  //}

}

// =================== VARIABLES ===================
// Path
boolean visualize_path = false;                          // visualize all possible path

float radius = 100.0f;                                    // obstacle radius
ArrayList <Point> points = new ArrayList<Point>();       // random points in canvas
ArrayList <Path> paths   = new ArrayList<Path>();        // paths connected to apply SPF.
ArrayList <Path> realpath  = new ArrayList<Path>();      // real path that is from paths.

int number_of_points = 10;    // shows how many points that is connected as paths.

// Actors
float actor_radius = 20;
Actor actor = new Actor();

// Obstacles
Point obstacle = new Point (250, 250);


// Points
class Point {
  float x, y;
  int num;

  Point(int n) {
    x = random(500);
    y = random(500);
    num = n;
  }

  Point(float x_, float y_) {
    x = x_;
    y = y_;
    num = -1;
  }

  Point(float x_, float y_, int n) {
    x = x_;
    y = y_;
    num = n;
  }


  public void print() {
    println("(",x,",",y,")");
  }

  public void display() {
    pushMatrix();
    stroke(color(255,0,10));
    point(x,y);
    popMatrix();
  }
}

// find distance between two points.
public float dist(Point a, Point b) {
  return sqrt(pow(b.x-a.x,2) + pow(b.y-a.y,2));
}



// Path
class Path {
  Point a, b;
  int start_pos, end_pos;
  float d;

  Path(Point p1, Point p2) {
    a = p1;
    b = p2;
    start_pos = p1.num;
    end_pos   = p2.num;
    d = dist(p1, p2);
  }

  Path(Point p1, Point p2, float d_) {
    a = p1;
    b = p2;
    start_pos = p1.num;
    end_pos   = p2.num;
    d = d_;
  }

  public void display() {
    pushMatrix();
    stroke(color(0,255,0,10));
    line(a.x, a.y, b.x, b.y);
    popMatrix();
  }

  public void display_red() {
    pushMatrix();
    stroke(color(255,0,0));
    line(a.x, a.y, b.x, b.y);
    popMatrix();
  }

  public void print() {
    println("FROM: (", a.x, a.y, ")     TO: (", b.x, b.y, ")");
    println("======START POSITION :", start_pos);
    println("======  END POSITION :", end_pos);
  }
}


// Boolean function that checks whether or not line intersects with sphere.
public boolean lineIntersectSphere (Point p1, Point p2, Point o, float r) {
  float len = dist(p1, p2);
  float dot = ((o.x - p1.x)*(p2.x-p1.x) + (o.y - p1.y)*(p2.y-p1.y)) / (len*len);

  float closestX = p1.x + (dot * (p2.x-p1.x));
  float closestY = p1.y + (dot * (p2.y-p1.y));

  Point closest = new Point(closestX, closestY);
  float d1 = dist(closest, p1);
  float d2 = dist(closest, p2);
  if (d1 + d2 < len-0.1f || d1 + d2 > len + 0.1f) return false;


  float distance = dist(closest, o);
  if ( distance <= r ) {
    return true;
  } else {
    return false;
  }
}





// iniitial position,
public void init() {
  points.clear();            // empty the lists.
  paths.clear();
  realpath.clear();

  int index = 0;
  points.add(new Point(10, 490, index));
  while (index < number_of_points - 2) {
    Point p = new Point(index+1);
    if (dist(obstacle, p) > radius+actor_radius/2.0f) {
      index += 1;
      points.add(p);
    }
  }
  points.add(new Point(490,10, number_of_points-1));

  for (int i = 0; i < points.size(); i ++) {
    for (int j = i+1; j < points.size(); j ++) {
      Point p1 = points.get(i);
      Point p2 = points.get(j);
      if (!lineIntersectSphere(p1, p2, obstacle, radius+actor_radius/2.0f)) {
        paths.add(new Path(p1, p2));
      }
    }
  }

  Dijkstra();
}
  public void settings() {  size(500, 500, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Path_Finding" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
