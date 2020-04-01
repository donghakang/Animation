Camera camera;
PShape fish;
PShape rock;

int w = 3000;
int h = 400;
int s = 1000;
// float f = 0.0;
// float delta = 0.0;


void settings() {
  size(800, 680, P3D);
}



void setup() {
  camera = new Camera();
  camera.dimensional_view();
  fish = loadShape("./data/12265_Fish_v1_L2.obj");
  fish.scale(2);

  rock = loadShape("./data/stone_podest_OBJ.obj");
  rock.scale(30);
  rock.rotateX(PI);


  boids.clear();
  for (int i = 0; i < 100; i++) {
    Boid b = new Boid(random(0,w), random(0,h), random(0, s));
    boids.add(b);
  }

  o = new Obstacles();
}

void mousePressed() {
  Boid b = new Boid(random(0,w), random(0,h), random(0,s));
  boids.add(b);
}


void keyPressed() {
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

void keyReleased()
{
  camera.HandleKeyReleased();
}

void display_box () {
  pushMatrix();
  // noFill();
  noFill();
  translate(w/2, h/2, s/2);
  box(w,h,s);
  popMatrix();
}



void draw() {
  background(color(0, 180,255));
  lights();
  display_box();
  camera.Update( 1.0/frameRate );
  //camera.print();
  for (Boid b : boids) {
    b.boid();
  }

  camera.print();
  o.display();


}
