

class Cloud {
  float x, y;
  float speed;
  float size;

  Cloud() {
    x = width / 2;
    y = 50;
    speed = random(cloud_speed/2, cloud_speed);
    size  = random(30,50);
  }
  
  Cloud(float size_) {
    x = width / 2;
    y = 50;
    speed = random(cloud_speed/2, cloud_speed);
    size  = size_;
  }

  Cloud(float x_, float y_) {
    x = x_;
    y = y_;
    speed = random(cloud_speed/2, cloud_speed);
    size  = random(30, 50);
  }

  void move_around() {
    if (x > width+100) {
      x = -100;
      y     = random(0, 200);
      speed = random(cloud_speed/2, cloud_speed);
      //size  = random(30, 50);
    }
    x += speed;
  }

  void display() {
    move_around();   
    pushMatrix();
    cloud.disableStyle();  // Ignore the colors in the SVG
    fill((size - 30) + 70);    // Set the SVG fill to blue
    noStroke();
    shape(cloud, x, y, size, size);
    popMatrix();
    
  }
  
  void init() {
    move_around();
    display();
  }
}



// Initializing Cloud
void cloud_init(){
  cloud = loadShape("./data/1489136024.svg");
  cloud.scale(1.5); 
  for (int i = 0; i < cloud_count; i ++) {
    env_cloud.add(new Cloud(random(width), random(0, 200)));
  }
}

// Set up Cloud environment
void cloud_environment() {
  for (Cloud cloud : env_cloud) {
    cloud.init();
  }
}
