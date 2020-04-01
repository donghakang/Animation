
boolean OBSTACLE_MODE   = false;
boolean NAVIGATION_MODE = false;
boolean SHOW_PATH       = false;
boolean IS_PRM          = false;

boolean AGENT_MOVEMENT  = false;

void settings() {
  size(800, 600);
}


void init() {
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

void setup() {
  init();
}


void keyPressed() {
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

void mousePressed() {
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

float total_time = 0.0;
float temp__time = 0.0;
void explanation() {
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






void draw() {
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
