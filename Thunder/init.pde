import ddf.minim.*;

// Window Size
int width = 600;
int height = 600;


// Audio Player
Minim minim; 
AudioPlayer[] thunder = new AudioPlayer[3];


// RRT
ArrayList<Node> G = new ArrayList<Node>();
ArrayList<Edge> E = new ArrayList<Edge>();


// Cloud 
PShape cloud;

ArrayList<Cloud> env_cloud = new ArrayList <Cloud>();

int cloud_count   = 10;
float cloud_speed = 1.0;
int speed_status  = 4;      // 4 -- 1x,  3 -- 0.5x, 2 -- 0.25x, 1 -- 0.01x
Cloud main_cloud = new Cloud(42);


// Lightning
Lightning l = new Lightning();


/* ============================================================ */
/* ============================================================ */

void settings() {
  size(600, 600);
}


void setup() {
  reset_all();
  background(100);

  cloud_init();
  thunder_init();
}


void keyPressed() {
  if (keyCode == 'R') {
    reset_all();
  }
  if (keyCode == 'K') {
    thunder_play();
  }
  if (keyCode == '1') {
    lightning_display_speed(1);
  }
  if (keyCode == '2') {
    lightning_display_speed(2);
  }
  if (keyCode == '3') {
    lightning_display_speed(3);
  }
  if (keyCode == '4') {
    lightning_display_speed(4);
  }
}

void mouseClicked() {
  thunder_play();
}


void draw() {
  background(100);
 
  main_cloud.init();
  cloud_environment();
  
  if (mousePressed) {
    //enableRRT(new Node(main_cloud.x, main_cloud.y));
    RRT(new Node(main_cloud.x+25, main_cloud.y+50), 50, 20);
    //lightning_display();
    l.display();

    reset();
  }
}



void reset() {
  G.clear();
  E.clear();
}


void reset_all() {
  reset();
  env_cloud.clear();
  cloud_init();
}
