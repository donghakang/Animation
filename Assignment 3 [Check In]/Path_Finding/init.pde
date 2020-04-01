
// =================== VARIABLES ===================
// Path
boolean visualize_path = false;                          // visualize all possible path

float radius = 100.0;                                    // obstacle radius
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


  void print() {
    println("(",x,",",y,")");
  }

  void display() {
    pushMatrix();
    stroke(color(255,0,10));
    point(x,y);
    popMatrix();
  }
}

// find distance between two points.
float dist(Point a, Point b) {
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

  void display() {
    pushMatrix();
    stroke(color(0,255,0,10));
    line(a.x, a.y, b.x, b.y);
    popMatrix();
  }

  void display_red() {
    pushMatrix();
    stroke(color(255,0,0));
    line(a.x, a.y, b.x, b.y);
    popMatrix();
  }

  void print() {
    println("FROM: (", a.x, a.y, ")     TO: (", b.x, b.y, ")");
    println("======START POSITION :", start_pos);
    println("======  END POSITION :", end_pos);
  }
}


// Boolean function that checks whether or not line intersects with sphere.
boolean lineIntersectSphere (Point p1, Point p2, Point o, float r) {
  float len = dist(p1, p2);
  float dot = ((o.x - p1.x)*(p2.x-p1.x) + (o.y - p1.y)*(p2.y-p1.y)) / (len*len);

  float closestX = p1.x + (dot * (p2.x-p1.x));
  float closestY = p1.y + (dot * (p2.y-p1.y));

  Point closest = new Point(closestX, closestY);
  float d1 = dist(closest, p1);
  float d2 = dist(closest, p2);
  if (d1 + d2 < len-0.1 || d1 + d2 > len + 0.1) return false;


  float distance = dist(closest, o);
  if ( distance <= r ) {
    return true;
  } else {
    return false;
  }
}





// iniitial position,
void init() {
  points.clear();            // empty the lists.
  paths.clear();
  realpath.clear();

  int index = 0;
  points.add(new Point(10, 490, index));
  while (index < number_of_points - 2) {
    Point p = new Point(index+1);
    if (dist(obstacle, p) > radius+actor_radius/2.0) {
      index += 1;
      points.add(p);
    }
  }
  points.add(new Point(490,10, number_of_points-1));

  for (int i = 0; i < points.size(); i ++) {
    for (int j = i+1; j < points.size(); j ++) {
      Point p1 = points.get(i);
      Point p2 = points.get(j);
      if (!lineIntersectSphere(p1, p2, obstacle, radius+actor_radius/2.0)) {
        paths.add(new Path(p1, p2));
      }
    }
  }

  Dijkstra();
}
