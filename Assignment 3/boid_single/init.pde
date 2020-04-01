
int w = 750;
int h = 750;
String s = "";
boolean boid_on = true;



void settings() {
  size(750, 750);
}

void setup() {
  background(color(255,255,255));
  surface.setTitle("boid");
  init();
}

void init() {
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


void mousePressed() {
  Boid a = new Boid(mouseX, mouseY);
  boids.add(a);
}


void keyPressed() {
  if (keyCode == 'O') {
    boid_on = !boid_on;
  }
  if (keyCode == 'R') {
    init();
  }
}


void draw() {
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
