class Spring {
  float ballX;
  float ballY;
  float velX;
  float velY;
  float forceY;
  float forceX;
  
  Spring(float p_x, float p_y) {
    ballX = p_x;
    ballY = p_y;
    velX = 0;
    velY = 0;
    forceX = 0;
    forceY = 0;
  }
  
  Spring(float p_x, float p_y, float v_x, float v_y) {
    ballX = p_x;
    ballY = p_y;
    velX = v_x;
    velY = v_y;
    forceX = 0;
    forceY = 0;
  }
  
  float springForce(float p) {
    return -k * ((ballY - p) - restLen);
  }
  
  float dampForce(float v) {
    return -kv * (velY - v);
  }
  
 
  void yForce(float p, float v){
    float spring = -k * ((ballY - p) - restLen);
    float damp   = -kv * (velY - v);
    forceY       = spring + damp;
  }
 
  void accelerationY(float F, float dt) {
    float accY = gravity + .5 * forceY/mass - .5 * F/mass;
    velY  += accY * dt;
    ballY += velY * dt;
    
    if (ballY+radius > floor){
      velY *= -.9;
      ballY = floor - radius;
    }
  }
  
  void appear() {
    pushMatrix();
    line(ballX,stringTop,ballX,ballY);
    translate(ballX,ballY);
    sphere(radius);
    popMatrix();
  }
  
}
