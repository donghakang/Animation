// Dongha Kang
// AI Point finder






//Create Window
void setup() {
  size(500, 500, P3D);
  noStroke();
  surface.setTitle("Point Finding");
  
  init();
  actor.init_pos();
}




void keyPressed() {
  if (keyCode == 'R') {
    init();
    actor.init_pos();
  }
  if (keyCode == 'P') {
    visualize_path = !visualize_path;
  }
}



//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
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
