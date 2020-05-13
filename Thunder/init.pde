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
int magnitude = 3;
int l_dis = 50;
int l_len = 20;

// Time
float dt = 0;

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


  RRT(new Node(main_cloud.x+25, main_cloud.y+50), l_dis, l_len);
}


void keyPressed() {
  reset();
  RRT(new Node(main_cloud.x+25, main_cloud.y+50), l_dis, l_len);
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
  if (keyCode == UP) {
    magnitude ++;
    if (magnitude >= 5) magnitude = 5;
    magnitude_setup();
  }
  if (keyCode == DOWN) {
    magnitude --;
    if (magnitude <= 0) magnitude = 0;
    magnitude_setup();
  }
}

void mouseClicked() {
  thunder_play();
}

void mouseReleased() {
  background(255);
  if (speed_status != 4) {
    l.reset();
    reset();
    RRT(new Node(main_cloud.x+25, main_cloud.y+50), l_dis, l_len);
  }
}


void draw() {
  background(100);

  main_cloud.init();
  cloud_environment();

  if (mousePressed) {
    if (speed_status == 4) {
      reset();
      RRT(new Node(main_cloud.x+25, main_cloud.y+50), l_dis, l_len);
      l.display();
    }
    else {
      dt += 0.1;
      l.update();
    }
  }
  
  visualize_text();
}


void visualize_text() {
  fill(255);
  textSize(25);
  String speed_st = "";
  if (speed_status == 4) speed_st = "1.00x";
  if (speed_status == 3) speed_st = "0.50x";
  if (speed_status == 2) speed_st = "0.25x";
  if (speed_status == 1) speed_st = "0.10x";
  
  String mag_st = str(magnitude);
  
  
  text("Speed: " + speed_st, 10, 50); 
  text("Status: " + mag_st, 10, 80);
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
