/*
Algorithm BuildRRT
 Input: Initial configuration qinit, number of vertices in RRT K, incremental distance Δq)
 Output: RRT graph G
 
 G.init(qinit)
 for k = 1 to K do
 qrand ← RAND_CONF()
 qnear ← NEAREST_VERTEX(qrand, G)
 qnew ← NEW_CONF(qnear, qrand, Δq)
 G.add_vertex(qnew)
 G.add_edge(qnear, qnew)
 return G
 */
class Node {
  vec2 pos;
  int  num;

  Node() {
    pos = new vec2(0, 0);
    num = 0;
  }

  Node(float x, float y) {
    pos = new vec2(x, y);
    num = 0;
  }

  Node(float x, float y, int n) {
    pos = new vec2(x, y);
    num = n;
  }

  void display_red() {
    pushMatrix();
    fill(color(255, 0, 0));
    circle(pos.x, pos.y, 5);
    popMatrix();
  }
  
  void display_green() {
    pushMatrix();
    fill(color(0, 255, 0));
    circle(pos.x, pos.y, 5);
    popMatrix();
  }
  
  void display_blue() {
    pushMatrix();
    fill(color(0, 0, 255));
    circle(pos.x, pos.y, 5);
    popMatrix();
  }
  
  void display_white() {
    pushMatrix();
    fill(color(0, 0, 0));
    circle(pos.x, pos.y, 5);
    popMatrix();
  }
}



class Edge {
  Node n1;
  Node n2;
  boolean v;

  Edge(Node N1, Node N2) {
    n1 = N1;
    n2 = N2;
    v = false;
  }

  void display() {
    pushMatrix();
    strokeWeight(1);
    stroke(color(255,255,255));
    line(n1.pos.x, n1.pos.y, n2.pos.x, n2.pos.y);
    popMatrix();
  }
} 
 

 
 
 
Node random_state() {
  //float x_limit = random(width/2 - x_range, width/2 + x_range);
  //return new Node(x_limit, height);
  return new Node(random(mouseX-300, mouseX+300), height-30);
}
 
Node nearest_vertex(Node n, ArrayList<Node> G) {
  float distance = 1000;
  Node  Q = new Node();
  for (Node g : G) {
    if (dist(n.pos, g.pos) < distance) {    // 
      if (dist(n.pos, g.pos) > 0.01) {      // same node does not count
        distance = dist(n.pos, g.pos);
        Q = g;
      }
    }
  }
  return Q;
}

Node new_conf(Node near, Node rand, float delta) {
  /* 
   near: the random's nearest neighbor
   rand: generated point
   delta: step size
   */
   
  if (dist(near.pos, rand.pos) < delta) {
    return rand;
  } else {
    float x_dir  = rand.pos.x - near.pos.x;
    float y_dir  = rand.pos.y - near.pos.y;
    float dis    = sqrt(pow(x_dir, 2) + pow(y_dir, 2));
    Node q = new Node (near.pos.x + x_dir / dis * delta, near.pos.y + y_dir / dis * delta);
  
    return q;
  }
}



void RRT(Node x_init, int K, float q) {
  /*
  Input: Initial configuration qinit, number of vertices in RRT K, incremental distance Δq)
   Output: RRT graph G
   */

  G.add(x_init);
  for (int k = 0; k < K; k ++) {
    Node qrand = random_state();            // eventually change to random_state()
    Node qnear = nearest_vertex(qrand, G);
    Node qnew  = new_conf(qnear, qrand, q);
    G.add(qnew);
    
    E.add(new Edge(qnear, qnew));
    if (qnear.pos.y >= height - 30) {
      break;
    }
    else if (qnew.pos.y >= height - 30) {
      break;
    }
  }
}



void enableRRT(Node m) {
  RRT(m, 50, 5);
  reset();
}
