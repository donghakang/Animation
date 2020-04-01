


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

  void display() {
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

  void set(Point p) {
    pos = p.pos;
  }

  float distance(Point a) {
    return dist(pos, a.pos);
  }

  void print() {
    pos.print();
  }

  boolean inCanvas() {
    return pos.x > 0 && pos.x < width && pos.y > 0 && pos.y < height;
  }

  boolean inObstacle() {
    for (Obstacle o : obstacles) {
      if (dist(o.pos, pos) < o.size/2.0) {
        return true;
      }
    }
    return false;
  }

  void relocate() {
    pos = new vec2(random(0, width), random(0, height));
  }


  void display_start() {
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

  void display_dest() {
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

  void display() {
    pushMatrix();
    stroke(color(255,255,255));
    point(pos.x,pos.y);
    // fill(255);
    // circle(pos.x,pos.y,3);
    popMatrix();
  }

  void display(int n) {
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


  boolean intersect() {
    for (Obstacle o : obstacles) {
      float len = d;
      float dot = ((o.pos.x - a.pos.x)*(b.pos.x-a.pos.x) +
                   (o.pos.y - a.pos.y)*(b.pos.y-a.pos.y)) / (len*len);

      float closestX = a.pos.x + (dot * (b.pos.x-a.pos.x));
      float closestY = a.pos.y + (dot * (b.pos.y-a.pos.y));

      Point closest = new Point(closestX, closestY);
      float d1 = closest.distance(a);
      float d2 = closest.distance(b);
      if (d1 + d2 >= len-0.1 && d1 + d2 <= len + 0.1) {
        float distance = dist(closest.pos, o.pos);
        if ( distance <= o.size / 2 ) {
         return true;
        }
      }
    }
    return false;
  }


  void print() {
    println("FROM: (", a.pos.x, a.pos.y, ")     TO: (", b.pos.x, b.pos.y, ")");
    // println("======START POSITION :", start_pos);
    // println("======  END POSITION :", end_pos);
  }

  void display() {
    pushMatrix();
    stroke(color(0,255,0,20));
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
    popMatrix();
  }

  void display_red() {
    pushMatrix();
    stroke(color(255,0,0));
    line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
    popMatrix();
  }
}


void clear_path() {
  dijkstra_path.clear();
  A_path.clear();

  paths.clear();
  realpath.clear();

}

void connect_path() {
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

boolean isValid() {
  if (points[0].pos.x < 0 || points[1].pos.x > width ||
      points[1].pos.y < 0 || points[1].pos.y > height) {
    return false;
  } else {
    return true;
  }
}





// display all
void display_PRM() {
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
