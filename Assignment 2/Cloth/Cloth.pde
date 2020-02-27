// Dongha Kang

Camera camera;
PImage burger;


void setup() {
  size(600, 600, P3D);
  surface.setTitle("Cloth Simulation");
  
  burger = loadImage("data/burger.jpg");
  camera = new Camera();
  init();
}


boolean cut = false;


float restLen = 10;

float mass = .3;
float grav = 500; //0
float k = 5000; //1 1000
float kv = 10;


float sphereX = 260;
float sphereY = 250;
float sphereZ = 120;
float sphereR = 100;

// size
int num = 30;

Spring[][] springs = new Spring[num][num];


void init() {
  cut = false;
  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num; j ++) {
      springs[i][j] = new Spring(100+restLen*i, 100, 50+(restLen)*j);
    }
  }
}



void Force_Normal(float dt) {
  //// DRAG FORCE 
  //for (int i = 0; i < num - 1; i ++) {
  //  for (int j = 0; j < num -1; j ++) {
  //     dragForce(springs[i][j], springs[i+1][j], springs[i][j+1], springs[i+1][j+1]);
  //     //dragForce(springs[i+1][j], springs[i][j+1], springs[i][j], dt);
  //   }
  //}
  
  for (int i = 0; i < num - 1; i ++ ) {
    for (int j = 0; j < num; j ++ ) {
      if (cut && i == num/2) {
        continue;
      } else {
        ForceX(springs[i][j], springs[i+1][j], dt);
      }
    } 
  }
  
  for (int i = 0; i < num; i ++ ) {
    for (int j = 0; j < num-1; j ++ ) {
      ForceY(springs[i][j], springs[i][j+1], dt); 
    } 
  }

  
  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num; j ++) {
       springs[i][j].vel.y += grav * dt;
    }
  }
  
  
  
  if (!cut) {
    for (int i = 0; i < num; i++) {
      springs[i][0].vel.x = 0;
      springs[i][0].vel.y = 0;
      springs[i][0].vel.z = 0;
    }
  } else {
    // CUT
    springs[1][0].vel.x = 0;
    springs[1][0].vel.y = 0;
    springs[1][0].vel.z = 0;
    
    springs[num-1][0].vel.x = 0;
    springs[num-1][0].vel.y = 0;
    springs[num-1][0].vel.z = 0;
  }
}




void update(float dt){
  Force_Normal(dt);

  // Update Position.
  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num; j ++) {
      springs[i][j].updatePos(dt);
    }
  }
  
  
  // collision
  for (int i = 0; i < num; i ++) {
    for (int j = 0; j < num; j ++) {
      float x = springs[i][j].pos.x;
      float y = springs[i][j].pos.y;
      float z = springs[i][j].pos.z;
      
      vec3 d = new vec3( x - sphereX, y - sphereY, z - sphereZ);
      if (d.dist() < sphereR + 1) {
        vec3 n = new vec3( -1 * (sphereX - x), -1 * (sphereY - y), -1 * (sphereZ - z));    // surface normal 
        n.normalize();
        // bounce = np.multiply(np.dot(v[i,j],n),n)
        float dott = dot(springs[i][j].vel, n);
        vec3 bounce = n.multiplyBy(dott);
        springs[i][j].vel.x -= 1.5 * bounce.x;
        springs[i][j].vel.y -= 1.5 * bounce.y;
        springs[i][j].vel.z -= 1.5 * bounce.z;
        
        springs[i][j].pos.x += (1 + sphereR - d.dist()) * n.x;
        springs[i][j].pos.y += (1 + sphereR - d.dist()) * n.y;
        springs[i][j].pos.z += (1 + sphereR - d.dist()) * n.z;
        // v[i,j] -= 1.5*bounce
        // p[i,j] += np.multiply(.1 + sphereR - d, n) #move out
      }
    }
  }
}

void keyPressed() {
  camera.HandleKeyPressed();
  if (keyCode == 'R') {
    init();
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}


void mouseDragged() {
  cut = true;
}  

void draw() {
  background(255,255,255);
  lights();
  noStroke();
  String runtimeReport = "";
  for (int i = 0; i < 10; i++){
    update(1/(10*frameRate));
    //update(0.1);
  }
  camera.Update( 1.0/frameRate );
  //update(0.1);
 
  //println(camera.position, camera.theta, camera.phi);
  
  if (keyPressed) {
    if (keyCode == RIGHT) {
    sphereX += 1;
    }
    if (keyCode == LEFT) {
      sphereX -= 1;
    }
    if (keyCode == UP) {
      sphereZ += 1;
    }
    if (keyCode == DOWN) {
      sphereZ -= 1;
    }
  }
  // SPHERE
  pushMatrix();
  fill(0,200,100);
  translate(sphereX, sphereY, sphereZ);
  sphere(sphereR); 
  popMatrix();
  
  
  for (int i = 0; i < num - 1; i ++) {
    for (int j = 0; j < num - 1; j ++) {
      if (cut && i == num/2) {
         continue;
      } else {
        beginShape();
        //fill(255, 0, 0);
        fill(255,255,255);
        texture(burger);
        vertex(springs[i][j].pos.x, springs[i][j].pos.y, springs[i][j].pos.z, 20*i, 20*j);
        vertex(springs[i+1][j].pos.x, springs[i+1][j].pos.y, springs[i+1][j].pos.z, 20*(i+1), 20*j);
        vertex(springs[i+1][j+1].pos.x, springs[i+1][j+1].pos.y, springs[i+1][j+1].pos.z, 20*(i+1), 20*(j+1));
        vertex(springs[i][j+1].pos.x, springs[i][j+1].pos.y, springs[i][j+1].pos.z, 20*(i), 20 * (j+1));
        endShape();
      }
    }
  }
  
  runtimeReport = " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(runtimeReport);
}
