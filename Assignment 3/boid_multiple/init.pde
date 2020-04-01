

int w = 800;
int h = 680;
// float f = 0.0;
// float delta = 0.0;

void settings() {
  size(800, 680);
}

void setup() {
  boids.clear();
  for (int i = 0; i < 200; i++) {
    Boid b = new Boid(random(0,w), random(0,h));
    boids.add(b);
  }
}



void keyPressed() {
  if (keyCode == 'R') {
    setup();
  }
  if (keyCode == 'A') {
    Boid b = new Boid (width/2, height/2);
    boids.add(b);
  }
}

void environment() {
  String s = "Press 'R' to reposition\n\nPress 'A' to create \nmore points";
  pushMatrix();
  fill(255);
  textSize(14);
  text(s, 10, 50);
  popMatrix();
}


void draw() {
  // delta = millis() - f;
  // f = millis();
  background(color(0,0,0));
  environment();
  noFill();
  
  for (Boid b : boids) {
    b.boid();
  }
}
