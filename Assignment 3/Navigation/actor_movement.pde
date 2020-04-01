

Actor actor = new Actor();


class Actor {
  float x, y;
  //float s_x, s_y;        // slope
  //float s_length;        // distance
  int path_position;   // path position
  float vel;
  float radius = 15.0;

  Actor() {
    x = 0;
    y = 0;
    //s_x = 0;
    //s_y = 0;
    //s_length = 0;
    path_position = 0;
    vel    = 5;
  }

  void init_pos() {
    int s = realpath.size();
    path_position = s - 1;
    x = realpath.get(s-1).a.pos.x;
    y = realpath.get(s-1).a.pos.y;
  }

  void change_pos() {

    float distX = realpath.get(path_position).b.pos.x - x;
    float distY = realpath.get(path_position).b.pos.y - y;

    float distance = sqrt(distX*distX + distY*distY);
    // println(distance, radius);
    if ( distance < radius/4 ) {
      path_position -= 1;
    }
  }

  void update() {
    Path p = realpath.get(path_position);
    float startX = p.a.pos.x;
    float startY = p.a.pos.y;
    float endX   = p.b.pos.x;
    float endY   = p.b.pos.y;

    float s_y = endY - startY;
    float s_x = endX - startX;

    float s_length = dist(p.a.pos, p.b.pos);

    x += s_x / s_length * vel;
    y += s_y / s_length * vel;
  }


  // actor display
  void display() {
    pushMatrix();
    fill(color(255,255,255));
    stroke(color(255,255,255));
    circle(x, y, radius);
    popMatrix();
  }
}
